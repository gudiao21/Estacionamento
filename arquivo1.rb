require 'time'

#@placas = []

class Estacionamento
    @placas = []
    attr_accessor :placa, :carro, :nome, :pessoa

    def self.menu
        puts "\nO que deseja fazer?\n\n"
        puts "Digite (1) para cadastrar entrada do veículo."
        puts "Digite (2) para cadastrar saída do veículo."
        puts "Digite (3) para buscar placa."
        puts "Digite (4) para mostrar movimentação do dia."
        puts "Digite (5) para sair."
    end

    def captura_item_menu
        opcao = gets.to_i
        when 1
            Estacionamento.cadastrar_entrada
        when 2
            Estacionamento.cadastrar_saida
        when 3
            Estacionamento.busca_por_placa
        when 4        

    end    

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
        colaborador_encontrado = nil
        ControladorVacina.colaboradores.each do |colaborador|
        if colaborador.placa == placa
            colaborador_encontrado = colaborador
            break
        end
    end

    # colaborador_encontrado
        end    
            
    end

    def self.mostar
        puts "Placa do carro é #{@placa}"
        puts "O nome do carro é #{@nome}"
        puts "O nome do proprietário é #{@}"
    end


    def calcular_tempo_por_minuto
        minutos_estacionado = ((hora_saida - hora_entrada)/60).to_i
        tempo_total_estacionado = minutos_estacionado * 0.17
    end
    
end

Estacionamento.cadastrar_entrada