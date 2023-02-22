require 'time'

#@placas = []

class Estacionamento
    @placas = []
    attr_accessor :placa, :carro, :nome, :pessoa

    def self.cadastrar_entrada
        print "Por favor, entre com a placa do veículo: "
        @placa = gets.to_s.strip
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

    def self.busca_por_placa
        print "Digite a placa que está buscando: "
        if @placa = @placas
            
    end    


    def calcular_tempo_por_minuto
        minutos_estacionado = ((hora_saida - hora_entrada)/60).to_i
        tempo_total_estacionado = minutos_estacionado * 0.17
    end
    
end

#estacionamento = Estacionamento.new
Estacionamento.cadastrar_entrada