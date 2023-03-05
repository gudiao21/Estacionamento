require 'time'
require 'byebug'

#debugger
class Veiculo
    #attr_accessor :placa, :nome_veiculo, :dono_do_veiculo, :hora_entrada, :hora_saida
 
    # @veiculos = {}
    
    def mostrar_entrada_saida(placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida) #Método para cada veículo.
        system 'clear'
        puts "Placa do carro é #{placa}."
        puts "O nome do carro é #{nome_veiculo}."
        puts "O nome do proprietário é #{dono_do_veiculo}."
        puts "A hora de entrada foi #{hora_entrada}."
        if hora_saida == nil
            puts "A hora da saída ainda não foi registrada!"
            puts "=================================================="
        else    
            puts "A hora de saída foi #{hora_saida}."
            puts "=================================================="
        end    
        ControleVeiculos.pausa
    end

end

class ControleVeiculos #Sempre no padrão de codificação "Pascal Case".
    SAIR_DO_SISTEMA = 5
    
    @@veiculos = {}

    def initialize
        @veiculos = {}
        @novo_veiculo = {}
    end

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
            ControleVeiculos.relatorio
        when SAIR_DO_SISTEMA
            SAIR_DO_SISTEMA
        else
            puts "Você tem que digitar um número entre 1 a 5 apenas, por favor!"
            ControleVeiculos.pausa
            ControleVeiculos.menu
        end
    end
        
    def self.cadastrar_entrada
        #debugger
        @novo_veiculo = {}
        print "Digite a placa do veiculo: "
        @novo_veiculo[:placa] = gets.to_s.strip
        print "Digite o nome do veículo: "
        @novo_veiculo[:nome_veiculo] = gets.chomp
        print "Digite o nome do proprietário do veículo: "
        @novo_veiculo[:dono_do_veiculo] = gets.to_s.chomp
        print "Digite a hora de entrada do veículo: "
        @novo_veiculo[:hora_entrada] = Time.parse(gets.chomp)
        @@veiculos[@novo_veiculo[:placa]] = @novo_veiculo
        puts "+==========================================+"
        puts "|      VEÍCULO CADASTRADO COM SUCESSO.     |"
        puts "+==========================================+"
        ControleVeiculos.pausa
        ControleVeiculos.menu
    end

    def self.cadastrar_saida
        #debugger
        print "Digite a placa do veiculo: "
        @novo_veiculo[:placa] = gets.to_s.strip
      
        if @@veiculos.key?(@novo_veiculo[:placa])
            #veiculo = @@veiculos[@novo_veiculo[:placa]]
            print "Digite a hora de saída do veículo: "
            @novo_veiculo[:hora_saida] = Time.parse(gets.chomp)
            @@veiculos[@novo_veiculo[:placa]] = @novo_veiculo
            @@veiculos[@novo_veiculo[:placa]][:hora_saida] = @novo_veiculo[:hora_saida]
            puts "+==========================================+"
            puts "|       SAÍDA CADASTRADA COM SUCESSO.      |"
            puts "+==========================================+"
            ControleVeiculos.pausa

            ControleVeiculos.calculo(@novo_veiculo[:hora_entrada], @novo_veiculo[:hora_saida])
        else
            #ControleVeiculos.veiculo_nao_encontrado
            puts "Veículo de placa #{@novo_veiculo[:placa]} não encontrado!"
            print "Deseja ir para a opção: (1)CADASTRAR ENTRADA DE VEÍCULO? (S/N)"
            opcao = gets.to_s.upcase.strip

            case opcao
            when "S"
                ControleVeiculos.cadastrar_entrada
            when "N"
                ControleVeiculos.menu
            else
                system 'clear'
                puts "(S) ou (N) não escolhida, por isso te redirecionaremos para a opção do MENU!"
                ControleVeiculos.pausa
                ControleVeiculos.menu
            end    
          
        end
    end

    # def self.veiculo_nao_encontrado
    #     puts "Veículo de placa #{@novo_veiculo[:placa]} não encontrado!"
    #     print "Deseja ir para a opção: (1)CADASTRAR ENTRADA DE VEÍCULO? (S/N)"
    #     opcao = gets.to_s.strip
        
    # end
       
    def self.buscar_veiculo
        print "Digite a placa do veículo: "
        placa = gets.strip
        if @@veiculos.key?(placa) #Se "placa" já estiver sendo usada como chave em @@veiculos, o que indica que um veículo com essa placa já foi cadastrado.
          veiculo = @@veiculos[placa]
          puts "Veículo de placa #{veiculo} encontrado:"
          Veiculo.new.mostrar_entrada_saida(veiculo[:placa], veiculo[:nome_veiculo], veiculo[:dono_do_veiculo], veiculo[:hora_entrada], veiculo[:hora_saida])
        else
          puts "Veículo de placa #{veiculo} não encontrado!"
        end
        pausa
        # placa_procurada = nil
        # print "\nDigite a placa do veículo: "
        # placa_procurada = gets.to_s.strip
        # ControleVeiculos.loop_busca_em_comum(placa_procurada)
    end

    def self.relatorio
        puts @@veiculos
        ControleVeiculos.pausa
        ControleVeiculos.pausa
    end
    
    # def self.loop_busca_em_comum(placa_procurada)
        
        #ControleVeiculo.placas.find{ |veiculo| veiculo.placa == placa }
        
        # ControleVeiculos.veiculos.each do |placa, veiculo|
        # debugger
        #     if veiculo == placa_procurada
        #         puts "O veículo de placa #{placa_procurada} foi encontrado. \n\n"
        #         veiculo_encontrado = veiculo
        #         placa = ControleVeiculos.veiculos[:placa]
        #         nome_veiculo = ControleVeiculos.veiculos[:nome_veiculo]
        #         dono_do_veiculo = ControleVeiculos.veiculos[:dono_do_veiculo]
        #         hora_entrada = ControleVeiculos.veiculos[:hora_entrada]
        #         hora_saida = ControleVeiculos.veiculos[:hora_saida]
        #         hora_saida = ControleVeiculos.veiculos[:hora_saida]
        #         if hora_saida == nil
        #             veiculo = Veiculo.new
        #             veiculo.mostrar(placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida)
        #             puts "==========================================================="
        #             ControleVeiculos.pausa
        #             break
        #         else
        #             ControleVeiculos.calculo
        #         end
        #     else
        #         puts "Veículo de placa #{placa_procurada} não encontrado."
        #         puts "Deseja cadastrar a placa? (S/N)"
        #         opcao = gets.strip.upcase
        #         if opcao == "S"
        #             ControleVeiculo.cadastrar_entrada
                            #puts "====================================="
                            #veiculo.mostrar
                            #ControleVacina.pausa
    #             else
    #                 break
    #             end
    #         end
                
    #     end
    # end        


    def self.calculo(hora_entrada, hora_saida)
        minuto_total = ((hora_saida) - (hora_entrada))/60
        resultado = minuto_total * 0.17
        puts "O valor total a pagar ficou em: #{sprintf('R$ %.2f', resultado)}."
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