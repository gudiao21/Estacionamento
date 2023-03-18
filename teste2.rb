require 'time'
require 'byebug'
#require 'term/ansicolor'
#require 'pastel'


#debugger
class Veiculo
        
    def mostrar_entrada_saida(placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida) #Método para cada veículo.
        system 'clear'
        #debugger
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
        ControleVeiculos.volta_menu
    end
    #dados[:total_a_pagar] ? ("%.2f" % dados[:total_a_pagar]) : ""
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
        puts "Digite (3) para buscar veículo por placa."
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
        system 'clear'
        puts "\n|----- Voce escolheu a opção: (1)CADASTRAR ENTRADA DO VEÍCULO -----|\n\n"
        @novo_veiculo = {}
        
        placa = ""
        print "Digite a placa do veículo: "
        while (placa = gets.to_s.strip).empty?
            system 'clear'
            print "A placa do veículo não pode ser vazia, digite novamente: "
        end
          
        if @@veiculos.has_key?(placa)
            puts "Essa placa (#{placa}) já foi cadastrada!"
            ControleVeiculos.volta_menu
        else
            @@veiculos[:total_a_pagar] ? ("%.2f" % @@veiculos[:total_a_pagar]) : ""
            @novo_veiculo[:placa] = placa
        end
        
        print "Digite o nome do veículo: "
        while (nome_veiculo = gets.to_s.strip).empty?
            print "Nome do veículo não pode ser vazio, digite novamente: "
        end
        @novo_veiculo[:nome_veiculo] = nome_veiculo
        
        print "Digite o nome do proprietário do veículo: "
        while (dono_do_veiculo = gets.to_s.strip).empty?
            print "Nome do dono do veículo não pode ser vazio, digite novamente: "
        end
        @novo_veiculo[:dono_do_veiculo] = dono_do_veiculo
        #debugger
        print "Digite a hora de entrada do veículo (formato: HH:MM): "
        hora_entrada = gets.to_s.strip.chomp
        until (hora_entrada).match?(/^\d{2}:\d{2}$/)
            print "Hora de entrada inválida, digite novamente (formato: HH:MM): "
            hora_entrada = gets.to_s.strip.chomp
        end
        #debugger
        @novo_veiculo[:hora_entrada] = hora_entrada
        #@@veiculos[placa][:hora_entrada] = hora_entrada
        begin
            #@novo_veiculo[:hora_entrada] = DateTime.parse(hora_entrada).to_time

        rescue ArgumentError
            print "Hora de entrada inválida, tente novamente: "
            retry
        end
                
        @@veiculos[@novo_veiculo[:placa]]= @novo_veiculo
        puts "+==========================================+"
        puts "|      VEÍCULO CADASTRADO COM SUCESSO.     |"
        puts "+==========================================+"
        ControleVeiculos.volta_menu
    end

    def self.cadastrar_saida
        #debugger
        system 'clear'
        puts "\n|----- Voce escolheu a opção: (2)CADASTRAR SAÍDA DO VEÍCULO -----|\n\n"
        print "Digite a placa do veiculo: "
        placa = gets.to_s.strip
        #debugger

        #debugger
        if @@veiculos.key?(placa) && @@veiculos[placa][:hora_saida].nil?
            #debugger
            @novo_veiculo = @@veiculos[placa]
            hora_saida = nil

            print "Digite a hora de saída do veículo (formato: HH:MM): "
            hora_saida = gets.to_s.strip.chomp
            until (hora_saida).match?(/^\d{2}:\d{2}$/)
                print "Hora de saída inválida, digite novamente (formato: HH:MM): "
                hora_saida = gets.to_s.strip.chomp
            end
            begin
                @novo_veiculo[:hora_saida] = DateTime.parse(hora_saida).to_time
    
            rescue ArgumentError
                print "Hora de saída inválida, tente novamente: "
                retry
            end
            #hora_saida = Time.strptime(hora_saida_string, "%H:%M")
            #hora_saida = Time.parse(hora_saida_string)
            #debugger
            @@veiculos[placa][:hora_saida] = hora_saida #Corrigido 07/03/23, estava @@veiculos[:placa] ...
            puts "+==========================================+"
            puts "|       SAÍDA CADASTRADA COM SUCESSO.      |"
            puts "+==========================================+"
            #debugger
            ControleVeiculos.calculo(@@veiculos[placa][:placa], @@veiculos[placa][:hora_entrada], hora_saida)

        elsif @@veiculos.key?(placa) && @@veiculos[placa][:hora_saida]
            puts "Hora de saída já registrada para essa placa!"
            ControleVeiculos.volta_menu

        else
            puts "\n\n"
            puts "+-----------------------------------------------------------------+"
            puts "|        A placa (#{placa}) ainda não foi cadastrada.             |"
            puts "| Deseja ir para a opção: (1)CADASTRAR ENTRADA DE VEÍCULO? (S/N)  |"
            puts "|                                                                 |"
            puts "+-----------------------------------------------------------------+"
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
        system 'clear'
        puts "\n|----- Voce escolheu a opção: (3)BUSCAR VEÍCULO POR PLACA -----|\n\n"
        #debugger
        print "Digite a placa do veículo: "
        placa = gets.strip
        if @@veiculos.key?(placa) #Se "placa" já estiver sendo usada como chave em @@veiculos, o que indica que um veículo com essa placa já foi cadastrado.
            veiculo = @@veiculos[placa]
            puts "Veículo de placa #{veiculo[:placa]} encontrado!"
            Veiculo.new.mostrar_entrada_saida(veiculo[:placa], veiculo[:nome_veiculo], veiculo[:dono_do_veiculo], veiculo[:hora_entrada], veiculo[:hora_saida])
        else
            puts "Veículo de placa #{veiculo} não encontrado!"
        end
        ControleVeiculos.volta_menu
    end

    def self.relatorio
        #debugger
        system 'clear'
        # Define as larguras máximas de cada coluna
        placa_width = 5
        nome_veiculo_width = 20
        dono_do_veiculo_width = 20
        hora_entrada_width = 32
        hora_saida_width = 32
        total_a_pagar_width = 14
        subtotais = 50

        # Cria a string de formatação
        format_string = "%-#{placa_width}s  %-#{nome_veiculo_width}s  %-#{dono_do_veiculo_width}s  %-#{hora_entrada_width}s  %-#{hora_saida_width}s  %-#{total_a_pagar_width}s  %-#{subtotais}s\n"

        # Imprime o cabeçalho
        puts "====================================================================================================================================================="
        puts format_string % ["Placa", "Nome do Veículo", "Dono do Veículo", "Hora de Entrada", "Hora de Saída", "Total a Pagar", "Subtotais"]
        puts "====================================================================================================================================================="
        #debugger    
        ControleVeiculos.calcular_subtotal
        # Percorre todos os veículos e os imprime formatados:
        @@veiculos.each do |placa, dados|
        # Substitui valores nulos ou vazios por uma string vazia:    
        placa = placa.nil? ? "" : placa
        nome_veiculo = dados[:nome_veiculo].nil? ? "" : dados[:nome_veiculo]
        dono_do_veiculo = dados[:dono_do_veiculo].nil? ? "" : dados[:dono_do_veiculo]
        hora_entrada = dados[:hora_entrada].nil? ? "" : dados[:hora_entrada]
        hora_saida = dados[:hora_saida].nil? ? "" : dados[:hora_saida]
        total_a_pagar = dados[:total_a_pagar].nil? ? "" : "%.2f" % dados[:total_a_pagar]
        subtotal = dados[:subtotal].nil? ? "" : "%.2f" % dados[:subtotal]
        printf(format_string, placa, dados[:nome_veiculo], dados[:dono_do_veiculo], dados[:hora_entrada], dados[:hora_saida], dados[:total_a_pagar] ? ("%.2f" % dados[:total_a_pagar]) : 0, dados[:subtotal] ? ("%.2f" % dados[:subtotal]) : 0)
    end
        ControleVeiculos.volta_menu
    end
    
    def self.calculo(placa, hora_entrada, hora_saida)
        #debugger
        hora_entrada = Time.strptime(hora_entrada, "%H:%M")
        hora_saida = Time.strptime(hora_saida, "%H:%M")
        minuto_total = ((hora_saida) - (hora_entrada)) / 60
        resultado = minuto_total * 0.17
        @@veiculos[placa][:total_a_pagar] = resultado
        puts "+====================================+"
        puts "|  O VALOR TOTAL A PAGAR É: #{sprintf('R$ %.2f', resultado)}. |"
        puts "+====================================+"
        ControleVeiculos.volta_menu
    end

    def self.calcular_subtotal
        subtotal = 0
        @@veiculos.each do |placa, dados|
        subtotal += dados[:total_a_pagar] || 0
        @@veiculos[placa][:subtotal] = subtotal
        end
   end
      

    def self.volta_menu
        puts "+---------------------------------------------+"
        puts "|  Digite (M) para voltar ao MENU PRINCIPAL.  |"
        puts "+---------------------------------------------+"
        opcao = gets.to_s.upcase.strip.chomp
        while opcao != "M"
            system 'clear'
            puts "+-------------------------------------+"
            puts "|Obrigatoriamente tem que digitar (M).|"
            puts "|  Digite (M) para o MENU principal.  |"
            puts "+-------------------------------------+"
            opcao = gets.to_s.upcase.strip.chomp
        end
        opcao = "M"
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