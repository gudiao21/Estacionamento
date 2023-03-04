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
        #novo_veiculo = {placa:placa, nome_veiculo: nome_veiculo, dono_do_veiculo: dono_do_veiculo, hora_entrada: hora_entrada}
        #ControleVeiculos.veiculos
        puts "+==========================================+"
        puts "|      VEÍCULO CADASTRADO COM SUCESSO.     |"
        puts "+==========================================+"
        ControleVeiculos.pausa
        ControleVeiculos.menu
    end

    def self.cadastrar_saida
        print "Digite a placa do veiculo: "
        @novo_veiculo[:placa] = gets.to_s.strip
        if @novo_veiculo[:placa] == @@veiculos[:placa]
            print "Digite o horário de saída do veículo: "
            novo_veiculo[:hora_saida] = Time.parse(gets.chomp)
        else
            puts "Placa não encontrada no sistema. Deseja fazer um novo cadastro de entrada? (S/N)"
                opcao = gets.to_s.chomp.strip
                case opcao
                when "S"
                    ControleVeiculos.cadastrar_entrada
                when "N"
                    puts "VOCÊ ESCOLHEU (N)! VOLTANDO PARA O MENU PRINCIPAL."
                    ControleVeiculos.menu
                else
                    puts "VOCÊ DIGITOU ALGO DIFERENTE DE (S/N), POR FAVOR SE LIMITE ÀS DUAS OPÇÕES APENAS!"    
                end
        end
    end
       
    def self.buscar_veiculo
        print "Digite a placa do veículo: "
        placa = gets.strip
        if @@veiculos.key?(placa)
          veiculo = @@veiculos[placa]
          puts "Veículo encontrado:"
          Veiculo.new.mostrar(veiculo[:placa], veiculo[:nome_veiculo], veiculo[:dono_do_veiculo], veiculo[:hora_entrada], veiculo[:hora_saida])
        else
          puts "Veículo não encontrado"
        end
        pausa
        # placa_procurada = nil
        # print "\nDigite a placa do veículo: "
        # placa_procurada = gets.to_s.strip
        # ControleVeiculos.loop_busca_em_comum(placa_procurada)
    end


    def self.loop_busca_em_comum(placa_procurada)
        
        #ControleVeiculo.placas.find{ |veiculo| veiculo.placa == placa }
        
        ControleVeiculos.veiculos.each do |placa, veiculo|
        #debugger
            if veiculo == placa_procurada
                puts "O veículo de placa #{placa_procurada} foi encontrado. \n\n"
                veiculo_encontrado = veiculo
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