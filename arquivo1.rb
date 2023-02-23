require 'time'
require 'byebug'

#@placas = []

class Veiculo
    attr_accessor :placa, :carro, :nome_veiculo, :pessoa #"pessoa" seria o dono do carro.

    def self.busca_por_placa(placa)
        veiculo_encontrado = nil
        ControleVeiculo.placa.each do |veiculo|
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
        puts "O nome do proprietário é #{@pessoa}."
        puts "A hora de entrada foi #{hora_entrada}."
        if hora_saida == nil
            puts 'A hora de saída ainda não foi registrada.'
        else
            puts "A hora de saída foi #{hora_saida}."
        end
    end

end

classe ControleVeiculo #Sempre no formato "Pascal Case".
    @@placas = []
    #@@pessoas = []
    SAIR_DO_SISTEMA = 5
    
    # def self.pessoas
    #     @@pessoas
    # end

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
            
        end

    end

    def self.cadastrar_entrada
        print "Por favor, entre com a placa do veículo: "
        @placa = gets.strip
        @placas << @placa
        print "Entre com o nome do carro: "
        @carro = gets.to_s.strip
        print "Entre com o nome do proprietário: "
        @nome = gets.to_s.strip.chomp
        puts = "Entre com o nome do proprietário do veículo: "
        @pessoa = gets.to_s.strip
        print "Entre com a hora de entrada: "
        hora_entrada = Time.parse(gets.chomp)
        puts "Alguns minutos depois ....".upcase
        sleep(2)
        cadastrar_saida
    end

    def self.cadastrar_saida
        print "Entre com a hora da saída: "
        hora_saida = Time.parse(gets.chomp)
    end

    def calcular_tempo_por_minuto
        minutos_estacionado = ((hora_saida - hora_entrada)/60).to_i
        tempo_total_estacionado = minutos_estacionado * 0.17
    end

    #Estacionamento.cadastrar_entrada
end