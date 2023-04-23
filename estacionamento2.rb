require 'time'
require 'byebug'
require 'json'
require 'pg'
require 'term/ansicolor'
require 'pastel'
require_relative 'database'

class Carro
  attr_accessor :placa, :nome_veiculo, :dono_do_veiculo, :hora_entrada, :hora_saida, :total_a_pagar_por_veiculo, :subtotal
end

# class CadastroVeiculo
#   attr_accessor :hora_entrada, :hora_saida, :total_a_pagar_por_veiculo
# end

class ControleVeiculos
  @@veiculos = {}
  def self.cadastrar_entrada
    system 'clear'
    carro = Carro.new
    print "Entre com a placa do veículo: "
    carro.placa = gets.chomp
    print "Entre com o nome do veículo: "
    carro.nome_veiculo = gets.chomp
    print "Entre com o nome do dono do veículo: "
    carro.dono_do_veiculo = gets.chomp
    print "Entre com o horário de entrada do veículo: "
    #cadastroveiculo = CadastroVeiculo.new
    carro.hora_entrada = gets.chomp
    @@veiculos[carro.placa] = {carro: carro}
    # debugger
  end

  def self.cadastrar_saida
    system 'clear'
    carro = Carro.new
    print "Digite a placa do veículo: "
    carro.placa = gets.chomp
    print "Digite a hora de saída do veículo: "
    #cadastroveiculo = CadastroVeiculo.new
    carro.hora_saida = gets.chomp
    @@veiculos[carro.placa][:carro].hora_saida = carro.hora_saida
     # debugger
    ControleVeiculos.calculo(@@veiculos[carro.placa][:carro].placa, @@veiculos[carro.placa][:carro].hora_entrada, @@veiculos[carro.placa][:carro].hora_saida)
  end
  # debugger
  def self.calculo(placa, hora_entrada, hora_saida)
    #debugger
    hora_entrada = Time.strptime(hora_entrada, "%H:%M")
    hora_saida = Time.strptime(hora_saida, "%H:%M")
    minuto_total = ((hora_saida) - (hora_entrada)) / 60
    resultado = minuto_total * 0.17
    @@veiculos[placa][:total_a_pagar_por_veiculo] = resultado
    puts "+====================================+"
    puts "|  O VALOR TOTAL A PAGAR É: #{sprintf('R$ %.2f', resultado)}. |"
    puts "+====================================+"
  end

  def self.calcular_subtotal
    subtotal = 0
    @@veiculos.each do |placa, dados|
      subtotal += dados[:total_a_pagar_por_veiculo] || 0
      @@veiculos[placa][:carro].subtotal = subtotal
      #debugger
    end
  end
end

ControleVeiculos.cadastrar_entrada
ControleVeiculos.cadastrar_saida
ControleVeiculos.calcular_subtotal
