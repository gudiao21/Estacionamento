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

class CadastramentoVeiculo
  SAIR_DO_SISTEMA = 7

  def self.menu
    system 'clear'
    puts "\nO que deseja fazer?\n\n"
    puts "Digite (1) para cadastrar entrada do veículo."
    puts "Digite (2) para cadastrar saída do veículo."
    puts "Digite (3) para buscar veículo por placa."
    puts "Digite (4) para relatório corrente."
    puts "Digite (5) para deletar um registro de veículo."
    puts "Digite (6) editar um registro de um veículo"
    puts "Digite (7) para sair."
    puts "====================================================="
    CadastramentoVeiculo.captura_item_menu
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
    when 5
      CadastramentoVeiculo.volta_menu
    when 6
      Veiculo.editar_veiculo
    when SAIR_DO_SISTEMA
      SAIR_DO_SISTEMA
    else
      puts "Você tem que digitar um número entre 1 a 5 apenas, por favor!"
      CadastramentoVeiculo.pausa
      CadastramentoVeiculo.menu
    end
  end

    def self.init
      while(true)
        choice = CadastramentoVeiculo.menu
        break if choice == SAIR_DO_SISTEMA
      end
    end

  def self.volta_menu
    puts "+---------------------------------------------+"
    puts "|  Digite (M) para voltar ao MENU PRINCIPAL.  |"
    puts "+---------------------------------------------+"
    decisao = gets.to_s.upcase.strip.chomp
    while decisao != "M"
      system 'clear'
      puts "+-------------------------------------+"
      puts "|Obrigatoriamente tem que digitar (M).|"
      puts "|  Digite (M) para o MENU principal.  |"
      puts "+-------------------------------------+"
      decisao = gets.to_s.upcase.strip.chomp
    end
    decisao = "M"
    CadastramentoVeiculo.menu
  end

  def self.pausa
    sleep(4)
  end

  def self.mostrar_entrada_saida(placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida, total_a_pagar_por_veiculo) #Método para cada veículo.
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
      puts "Total a pagar foi de #{sprintf('%.2f' , total_a_pagar_por_veiculo)}."
      puts "=================================================="
    end
    CadastramentoVeiculo.volta_menu
  end

end

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
    ControleVeiculos.calculo(@@veiculos[carro.placa][:carro].placa, @@veiculos[carro.placa][:carro].hora_entrada, @@veiculos[carro.placa][:carro].hora_saida)
  end

  def self.calculo(placa, hora_entrada, hora_saida)
    #debugger
    hora_entrada = Time.strptime(hora_entrada, "%H:%M")
    hora_saida = Time.strptime(hora_saida, "%H:%M")
    minuto_total = ((hora_saida) - (hora_entrada)) / 60
    resultado = minuto_total * 0.17
    carro = Carro.new
    @@veiculos[placa][:carro].total_a_pagar_por_veiculo = resultado
    puts "+====================================+"
    puts "|  O VALOR TOTAL A PAGAR É: #{sprintf('R$ %.2f', resultado)}. |"
    puts "+====================================+"
  end

  def self.calcular_subtotal
    subtotal = 0
    @@veiculos.each do |placa, dados|
    subtotal += dados[:total_a_pagar_por_veiculo] || 0
    @@veiculos[placa][:carro].subtotal = subtotal
    end
  end

  def self.buscar_veiculo
    system 'clear'
    puts "\n|----- Voce escolheu a opção: (3)BUSCAR VEÍCULO POR PLACA -----|\n\n"
    print "Digite a placa do veículo: "
    placa = gets.strip
    if @@veiculos.key?(placa) #Se "placa" já estiver sendo usada como chave em @@veiculos, o que indica que um veículo com essa placa já foi cadastrado.
      veiculo = @@veiculos[placa][:carro].placa
      puts "Veículo de placa #{veiculo} encontrado!"
      CadastramentoVeiculo.mostrar_entrada_saida(@@veiculos[placa][:carro].placa, @@veiculos[placa][:carro].nome_veiculo, @@veiculos[placa][:carro].dono_do_veiculo, @@veiculos[placa][:carro].hora_entrada, @@veiculos[placa][:carro].hora_saida, @@veiculos[placa][:carro].total_a_pagar_por_veiculo)
    else
      puts "Veículo de placa #{veiculo} não encontrado!"
    end
    CadastramentoVeiculo.volta_menu
  end

  def self.relatorio
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
    CadastramentoVeiculo.volta_menu
  end
end

CadastramentoVeiculo.init