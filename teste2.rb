require 'time'
require 'byebug'

#debugger
class Veiculo
    #attr_accessor :placa, :nome_veiculo, :dono_do_veiculo, :hora_entrada, :hora_saida
 
    # @veiculos = {}
    
    def mostrar(placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida) #Método para cada veículo.
        system 'clear'
        puts "Placa do carro é #{placa}."
        puts "O nome do carro é #{nome_veiculo}."
        puts "O nome do proprietário é #{dono_do_veiculo}."
        puts "A hora de entrada foi #{hora_entrada}."
        puts "A hora de saída foi #{hora_saida}."
        puts "=================================================="
        ControleVeiculos.pausa

    end

end

class ControleVeiculos #Sempre no padrão de codificação "Pascal Case".
    SAIR_DO_SISTEMA = 5
    
    @@veiculos = {}

    def self.veiculos
        @@veiculos
    end
        
    def self.menu
        system 'clear'
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
            ControleVeiculos.cadastrar_saida
        when 3
            ControleVeiculos.buscar_veiculo
        when 4

        when SAIR_DO_SISTEMA
            SAIR_DO_SISTEMA
        else
            puts "Você tem que digitar um número entre 1 a 5 apenas, por favor!"
            ControleVeiculos.pausa
            ControleVeiculos.menu
        end
    end
        
    def self.cadastrar_entrada
        print "Digite a placa do veiculo: "
        ControleVeiculos.veiculos[:placa] = gets.strip
        print "Digite o nome do veículo: "
        ControleVeiculos.veiculos[:nome_veiculo] = gets.chomp
        print "Digite o nome do proprietário do veículo: "
        ControleVeiculos.veiculos[:dono_do_veiculo] = gets.to_s.chomp
        print "Digite a hora de entrada do veículo: "
        ControleVeiculos.veiculos[:hora_entrada] = Time.parse(gets.chomp)
        puts "Veiculo Cadastrado com sucesso."
        puts "======================================"
        ControleVeiculos.pausa

    end

    def self.cadastrar_saida
        placa_procurada = nil
        print "Digite a placa do veiculo: "
        ControleVeiculos.veiculos[:placa] = gets.strip
        placa_procurada = ControleVeiculos.veiculos[:placa]
        print "Digite o horário de saída do veículo: "
        ControleVeiculos.veiculos[:hora_saida] = Time.parse(gets.chomp)
        ControleVeiculos.loop_busca_em_comum

    end
       
    def self.buscar_veiculo
        placa_procurada = nil
        print "\nDigite a placa do veículo: "
        placa_procurada = gets.strip
        ControleVeiculos.loop_busca_em_comum
    end


    def self.loop_busca_em_comum 
        
        #ControleVeiculo.placas.find{ |veiculo| veiculo.placa == placa }
        
        ControleVeiculos.veiculos.each do |placa, placa_procurada|
        #debugger
            if ControleVeiculos.veiculos[:placa] == placa_procurada
                puts "O veículo de placa #{placa_procurada} foi encontrado. \n\n"
                placa = ControleVeiculos.veiculos[:placa]
                nome_veiculo = ControleVeiculos.veiculos[:nome_veiculo]
                dono_do_veiculo = ControleVeiculos.veiculos[:dono_do_veiculo]
                hora_entrada = ControleVeiculos.veiculos[:hora_entrada]
                hora_saida = ControleVeiculos.veiculos[:hora_saida]
                hora_saida = ControleVeiculos.veiculos[:hora_saida]
                if hora_saida == nil
                    veiculo = Veiculo.new
                    veiculo.mostrar(placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida)
                    puts "==========================================================="
                    ControleVeiculos.pausa
                    break
                else
                    ControleVeiculos.calculo
                end    
            else
                puts "Veículo de placa #{placa_procurada} não encontrado."
                puts "Deseja cadastrar a placa? (S/N)"
                opcao = gets.strip.upcase
                if opcao == "S"
                    ControleVeiculo.cadastrar_entrada
                            #puts "====================================="
                            #veiculo.mostrar
                            #ControleVacina.pausa
                else
                    break
                end
            end
                
        end
    end        


    def self.calculo
        minuto_total = ((ControleVeiculos.veiculos[:hora_saida]) - (ControleVeiculos.veiculos[:hora_entrada]))/60
        resultado = minuto_total * 0.17
        puts "O valor total ficou em #{sprintf('R$ %.2f', resultado)}."
        ControleVeiculos.pausa
        ControleVeiculos.menu
    end

    def self.pausa
        sleep(4)
       
    end
    
    def self.init
        while(true)
          opcao = ControleVeiculos.menu
          break if opcao == SAIR_DO_SISTEMA
        end
    end

end

ControleVeiculos.init