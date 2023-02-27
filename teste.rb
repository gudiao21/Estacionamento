#Exemplar de código mostra como chamar um método dentro de uma classe, quando se está em um outro método dentro de outra diferente classe:

class MinhaClasse
    def meu_metodo
      puts "Olá do meu método!"
    end
end

class OutraClasse
    def chamar_metodo_da_outra_classe
      instancia_da_minha_classe = MinhaClasse.new
      instancia_da_minha_classe.meu_metodo
    end
end

outra_classe = OutraClasse.new
outra_classe.chamar_metodo_da_outra_classe

#============================================================

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
    
    @@placas = []

    def self.placas
        @@placas
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
        placa = gets.strip
        ControleVeiculos.placas << placa
        print "Entre com o nome do veiculo: "
        veiculo.nome_veiculo = gets.to_s.strip
        print "Entre com o nome do proprietário: "
        veiculo.dono_do_veiculo = gets.to_s.strip.chomp
        print "Entre com a hora de entrada: "
        veiculo.hora_entrada = Time.parse(gets.chomp)
        veiculo.hora_saida = nil
        puts "======================================"
    end

    def self.buscar_veiculo
        print "\nDigite a placa do veículo? "
        placa = gets.strip
        #ControleVeiculo.placas.find{ |veiculo| veiculo.placa == placa }
        veiculo_encontrado = nil
        ControleVeiculos.placas.each do |v|
            #debugger
            if v == placa
                veiculo_encontrado = v
                puts "O veículo de placa #{veiculo_encontrado} foi encontrado: \n\n"
                veiculo = Veiculo.new
                veiculo.placa = placa
                veiculo.mostrar(placa, nome_veiculo, dono_do_carro, hora_entrada, hora_saida)
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