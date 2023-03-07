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
        @novo_veiculo[:placa] = gets.to_s.chomp.strip
        print "Digite o nome do veículo: "
        @novo_veiculo[:nome_veiculo] = gets.to_s.strip.chomp
        print "Digite o nome do proprietário do veículo: "
        @novo_veiculo[:dono_do_veiculo] = gets.to_s.chomp
        print "Digite a hora de entrada do veículo: "
        @novo_veiculo[:hora_entrada] = Time.parse(gets.chomp)
        @@veiculos[@novo_veiculo[:placa]]= @novo_veiculo
        puts "+==========================================+"
        puts "|      VEÍCULO CADASTRADO COM SUCESSO.     |"
        puts "+==========================================+"
        ControleVeiculos.pausa
        ControleVeiculos.menu
    end

    def self.cadastrar_saida
        #debugger
        print "Digite a placa do veiculo: "
        placa = gets.to_s.strip
        puts "Você acabou de digitar #{placa} para a placa do veículo."
      
        if @@veiculos.key?(placa)
            debugger
            print "Digite a hora de saída do veículo: "
            hora_saida_string = gets.chomp
            puts "Hora de saída digitado: #{hora_saida_string}."
            hora_saida = Time.strptime(hora_saida_string, "%H:%M")
            @@veiculos[:placa][:hora_saida]= @novo_veiculo
            @@veiculos[@novo_veiculo[:placa]][:hora_saida] = hora_saida
            puts "+==========================================+"
            puts "|       SAÍDA CADASTRADA COM SUCESSO.      |"
            puts "+==========================================+"
            ControleVeiculos.pausa
            ControleVeiculos.calculo(@@veiculos[placa], [:hora_entrada], hora_saida)
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
       
    def self.buscar_veiculo
        #debugger
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

    end

    def self.relatorio
        #debugger
        puts "PLACA\tNOME DO VEÍCULO\tDONO DO VEÍCULO\tHORA ENTRADA\tHORA SAÍDA\tVALOR"
        puts "====================================================================================="
        
        @@veiculos.each do |placa, dados|
            printf("%s\t%s\t%s\t%s\t%s\t%.2f\n", placa, dados[:nome_veiculo], dados[:dono_do_veiculo], dados[:hora_entrada], dados[:hora_saida], dados[:valor] ? dados[:valor] : 0)
        end
        ControleVeiculos.pausa
        ControleVeiculos.pausa
    end
    
    def self.calculo(placa, hora_entrada, hora_saida)
        system 'clear'
        minuto_total = ((hora_saida) - (hora_entrada))/60
        resultado = minuto_total * 0.17
        puts "O VALOR TOTAL A PAGAR É: #{sprintf('R$ %.2f', resultado)}."
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