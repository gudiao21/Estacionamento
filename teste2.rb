require 'time'
require 'byebug'

#debugger
class Veiculo
    attr_accessor :placa, :nome_veiculo, :dono_do_veiculo, :hora_entrada, :hora_saida
 
    def mostrar(placa, nome_veiculo, dono_do_carro, hora_entrada, hora_saida) #Método para cada veículo.
        puts "Placa do carro é #{@placa}."
        puts "O nome do carro é #{@nome_veiculo}."
        puts "O nome do proprietário é #{@dono_do_carro}."
        puts "A hora de entrada foi #{@hora_entrada}."
        puts "A hora de saída foi #{@hora_saida}."
    end

end

class ControleVeiculos #Sempre no padrão de codificação "Pascal Case".
    SAIR_DO_SISTEMA = 5
    
    @@veiculos = {}

    def self.veiculos
        @@veiculos
    end
        
    def self.menu
        puts "\nO que deseja fazer?\n\n"
        puts "Digite (1) para cadastrar entrada do veículo."
        puts "Digite (2) para cadastrar saída do veículo."
        puts "Digite (3) para buscar placa."
        puts "Digite (4) para mostrar movimentação do dia."
        puts "Digite (5) para sair."
        puts "====================================================="
        ControleVeiculos.captura_item_menu
    end

    def self.captura_item_menu
        opcao = gets.to_i
        case opcao
        when 1
            ControleVeiculos.cadastrar_entrada
        when 2
            #ControleVeiculo.cadastrar_saida
        when 3
            ControleVeiculos.buscar_veiculo
        when 4

        when SAIR_DO_SISTEMA
            SAIR_DO_SISTEMA
        end
    end    
        
    def self.cadastrar_entrada()
        veiculo = Veiculo.new #Iniciado instância do objeto.
        print "Digite a placa do veiculo: "
        veiculos[:placa] = gets.strip
        print "Digite o nome do veículo: "
        veiculos[:nome_veiculo] = gets.chomp
        print "Digite o nome do proprietário do veículo: "
        veiculos[:dono_do_carro] = gets.to_s
        print "Digite a hora de entrada do veículo: "
        veiculos[:hora_entrada] = Time.parse(gets.chomp)
        puts "Veiculo Cadastrado com sucesso."
        puts "======================================"
    end

    def self.buscar_veiculo
        print "\nDigite a placa do veículo? "
        placa_procurada = gets.strip
        
        #ControleVeiculo.placas.find{ |veiculo| veiculo.placa == placa }
        ControleVeiculos.veiculos.each do |placa, tag|
            #debugger
            if tag == placa_procurada
                puts "O veículo de placa #{tag} foi encontrado: \n\n"
                veiculo = Veiculo.new
                veiculo.placa = tag
                veiculo.nome_veiculo = veiculos[:nome_veiculo]
                veiculo.dono_do_veiculo = veiculos[:dono_do_carro]
                veiculo.hora_entrada = veiculos[:hora_entrada]
                veiculo.hora_saida = veiculos[:hora_saida]
                #veiculo.nome_veiculo = nome_veiculo
                veiculo.mostrar(veiculo.placa, veiculo.nome_veiculo, veiculo.dono_do_veiculo, veiculo.hora_entrada, veiculo.hora_saida)
                puts "==========================================================="
                #ControleVeiculos.pausa
                break
            else
                puts "Veículo de placa #{placa} não encontrado."
                puts "Deseja cadastrar a placa? (S/N)"
                opcao = gets.strip.upcase
                if opcao == "S"
                    ControleVeiculo.cadastrar_entrada(placa)
                    #puts "====================================="
                    #veiculo.mostrar
                    #ControleVacina.pausa
                end
            end  
        
        end
    end

        #Veiculo.busca_por_placa(placa)

     def self.pausa
        sleep(3)
        system "clear"
    end
    
    def self.init
        while(true)
          opcao = ControleVeiculos.menu
          break if opcao == SAIR_DO_SISTEMA
        end
    end

end

ControleVeiculos.init