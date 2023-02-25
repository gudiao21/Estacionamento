require 'time'
#require 'byebug'

#debugger
class Veiculo
    attr_accessor :placa, :nome_veiculo, :dono_do_veiculo, :hora_entrada, :hora_saida
    # @@placas = []

    # def self.placas
    #     @@placas
    # end

    def self.busca_por_placa(placa)
        #ControladorVacina.colaboradores.find{ |colaborador| colaborador.cpf == cpf }
    
        veiculo_encontrado = nil
        ControleVeiculo.placas.each do |veiculo|
          if @placa == placa
            colaborador_encontrado = veiculo
            break
          end
        end
    
        veiculo_encontrado
    end

    def mostrar #Método para cada veículo.
        puts "Placa do carro é #{@placa}."
        puts "O nome do carro é #{@nome_veiculo}."
        puts "O nome do proprietário é #{@dono_do_carro}."
        puts "A hora de entrada foi #{hora_entrada}."
        puts "A hora de saída foi #{hora_saida}."
    end

end

class ControleVeiculo #Sempre no padrão de codificação "Pascal Case".
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
        ControleVeiculo.captura_item_menu
    end

    def self.captura_item_menu
        opcao = gets.to_i
        case opcao
        when 1
            ControleVeiculo.cadastrar_entrada
        when 2
            #ControleVeiculo.cadastrar_saida
        when 3
            ControleVeiculo.buscar_veiculo
        when 4

        when SAIR_DO_SISTEMA
            SAIR_DO_SISTEMA
        end
    end    
        
    def self.cadastrar_entrada
        veiculo = Veiculo.new #Iniciado instância do objeto.
        print "Digite a placa do veiculo: "
        placa = gets.strip
        @@placas << placa
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
        veiculo = Veiculo.busca_por_placa(placa)
    end    

    def self.init
        while(true)
          opcao = ControleVeiculo.menu
          break if opcao == SAIR_DO_SISTEMA
        end
    end

end

ControleVeiculo.init