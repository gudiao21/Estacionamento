require 'time'
#require 'byebug'

@@placas = []

class Veiculo
    attr_accessor :placa, :nome_veiculo, :dono_do_veiculo, :hora_entrada, :hora_saida
    
    def self.busca_por_placa(placa)
        veiculo_encontrado = nil
        @@placas.each do |veiculo|
            if veiculo.placa == placa
                veiculo_encontrado = veiculo
                break
            end
        end
            
        veiculo_encontrado
    end

    def mostar #Método para cada veículo.
        puts "Placa do carro é #{@placa}."
        puts "O nome do carro é #{@nome_veiculo}."
        puts "O nome do proprietário é #{@dono_do_carro}."
        puts "A hora de entrada foi #{hora_entrada}."
        puts "A hora de saída foi #{hora_saida}."
        
    end

end

class ControleVeiculo #Sempre no padrão de codificação "Pascal Case".
    @@placas = []
    SAIR_DO_SISTEMA = 5
    #@veiculo = Veiculo.new
    
    def self.placas
        @@placas = []
    end

    def self.menu
        puts "\nO que deseja fazer?\n\n"
        puts "Digite (1) para cadastrar entrada do veículo."
        puts "Digite (2) para cadastrar saída do veículo."
        puts "Digite (3) para buscar placa."
        puts "Digite (4) para mostrar movimentação do dia."
        puts "Digite (5) para sair."
        ControleVeiculo.captura_item_menu
    end

    def self.captura_item_menu
        opcao = gets.to_i
        case opcao
        when 1
            ControleVeiculo.cadastrar_entrada
        when 2
            ControleVeiculo.cadastrar_saida
        when 3
            ControleVeiculo.busca_por_placa
        when 4

        when SAIR_DO_SISTEMA
            SAIR_DO_SISTEMA
        end

    end

    def self.cadastrar_entrada
        veiculo = Veiculo.new
        print "Digite a placa do veiculo: "
        veiculo.placa = gets.strip
        print "Entre com o nome do veiculo: "
        veiculo.nome_veiculo = gets.to_s.strip
        print "Entre com o nome do proprietário: "
        veiculo.dono_do_veiculo = gets.to_s.strip.chomp

        ControleVeiculo.placas << veiculo.placa
        #return @placa #Depois de cadastrar, motrar o mesmo na tela.
        print "Entre com a hora de entrada: "
        veiculo.hora_entrada = Time.parse(gets.chomp)
        puts "======================================"
        #veiculo.mostrar
        #end
    end

    def self.cadastrar_saida
        veiculo = Veiculo.new
        print "Entre com a placa do veículo: "
        placa = gets.to_s.strip
        veiculo = Veiculo.busca_por_placa(placa)
        #veiculo.busca_por_placa(placa)
        if veiculo == nil
            puts "Esse veículo não deu entrada aqui no Estacionamento ainda!"
        else
            veiculo.hora_de_entrada = hora_de_entrada
            print "Entre com a hora da saída: "
            @hora_saida = Time.parse(gets.chomp)
            minutos_estacionado = ((@hora_saida - @veiculo.hora_entrada)/60).to_i
            valor_total_a_pagar = minutos_estacionado * 0.17
            puts "O tempo total gasto no estacionamento foi #{minutos_estacionado}"
            puts "O valor total a pagar foi de #{valor_total_a_pagar}"
            ControleVeiculo.listar_colaboradores
        end    
    end

    def self.listar_colaboradores
        system "clear"
        
        if ControleVeiculo.placas.length == 0
          puts "Não temos nenhuma placa em nossa base de dados ainda."
          ControladorVacina.pausa
          return
        end
        
        ControleVeiculo.placas.each do |placa|
        puts "======================================="
        veiculo.mostrar
        end
        ControleVeiculo.pausa
    end    
      
    def self.pausa
        sleep(3)
        system "clear"
    end
    
    def self.init
        while(true)
          opcao = ControleVeiculo.menu
          break if opcao == SAIR_DO_SISTEMA
        end
    end
end

ControleVeiculo.init