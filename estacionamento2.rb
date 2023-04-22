class Carro
  attr_accessor :placa, :nome_veiculo, :dono_do_veiculo
end

class CadastroVeiculo
  attr_accessor :hora_entrada, :hora_saida, :total_a_pagar
end

class ControleVeiculos
  def self.cadastrar_entrada
    carro = Carro.new
    print "Entre com a placa do veículo: "
    carro.placa = gets.chomp
    print "Entre com o nome do veículo: "
    carro.nome_veiculo = gets.chomp
    print "Entre com o nome do dono do veículo: "
    carro.dono_do_veiculo = gets.chomp
    print "Entre com o horário de entrada do veículo: "

  end

  def self.Cadastrar_saida
    carro = Carro.new
    print "Digite a placa do veículo: #{placa = carro.placa}"
    print "Digite a hora de saída do veículo: #{}"
  end

  def self.calculo

  end
end

ControleVeiculos.cadastrar_entrada