require 'time'
require 'byebug'
require 'json'
require 'pg'
require 'term/ansicolor'
require 'pastel'
require_relative 'database'

class Carro
  attr_accessor :placa, :nome_veiculo, :dono_do_veiculo, :hora_entrada, :hora_saida, :total_a_pagar_por_veiculo, :subtotais_acumulado
end

class CadastramentoVeiculo
  SAIR_DO_SISTEMA = 7

  def self.menu
    system 'clear'
    puts "\nO que deseja fazer?\n\n"
    puts "Digite (1) para cadastrar a entrada do veículo."
    puts "Digite (2) para cadastrar a saída do veículo."
    puts "Digite (3) para buscar o veículo por placa."
    puts "Digite (4) para gerar um relatório corrente."
    puts "Digite (5) para deletar um registro de um veículo."
    puts "Digite (6) para editar um registro de um veículo"
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
      ControleVeiculos.gerar_relatorio
    when 5
      ControleVeiculos.deletar
    when 6
      ControleVeiculos.editar_veiculo
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
    #CadastramentoVeiculo.volta_menu
  end

end

class ControleVeiculos
  @@veiculos = {}

  def self.cadastrar_entrada
    system 'clear'
    carro = Carro.new
    puts "+-----------------------------------------------------------+"
    puts "|Você escolheu a opção (1) para Cadastrar entrada do veículo|"
    puts "+-----------------------------------------------------------+\n\n"
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
    puts "+-----------------------------------------------------------+"
    puts "|Você escolheu a opção (2) para cadastrar a saída do veículo|"
    puts "+-----------------------------------------------------------+\n\n"
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

  def self.calcular_subtotal_acumulado
    subtotais_acumulado = 0
    @@veiculos.each do |key, value|
      placa = key
      carro = value[:carro]
      subtotais_acumulado += carro.total_a_pagar_por_veiculo || 0
      @@veiculos[placa][:carro].subtotais_acumulado = subtotais_acumulado
      #debugger
    end
  end

  def self.buscar_veiculo
    system 'clear'
    puts "+---------------------------------------------------------+"
    puts "|Você escolheu a opção (3) para buscar o veículo por placa|"
    puts "+---------------------------------------------------------+\n\n"
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

  def self.gerar_relatorio
    system 'clear'
    puts "+---------------------------------------------------------+"
    puts "|Você digitou a opção (4) para gerar um relatório corrente|"
    puts "+---------------------------------------------------------+"
    #debugger
    # Define as larguras máximas de cada coluna
    placa_width = 5
    nome_veiculo_width = 20
    dono_do_veiculo_width = 20
    hora_entrada_width = 32
    hora_saida_width = 32
    total_a_pagar_por_veiculo_width = 25
    subtotais_acumulado = 14

    # Cria a string de formatação
    format_string = "%-#{placa_width}s  %-#{nome_veiculo_width}s  %-#{dono_do_veiculo_width}s  %-#{hora_entrada_width}s  %-#{hora_saida_width}s  %-#{total_a_pagar_por_veiculo_width}s  %-#{subtotais_acumulado}s\n"

    # Imprime o cabeçalho
    puts "======================================================================================================================================================================"
    puts format_string % ["Placa", "Nome do Veículo", "Dono do Veículo", "Hora de Entrada", "Hora de Saída", "Total a Pagar por veículo", "Subtotais acumulados"]
    puts "======================================================================================================================================================================"
    ControleVeiculos.calcular_subtotal_acumulado
    # Percorre todos os veículos e os imprime formatados:
    @@veiculos.each do |key, value|
      carro = value[:carro]
      placa = carro.placa
      nome_veiculo = carro.nome_veiculo
      dono_do_veiculo = carro.dono_do_veiculo
      hora_entrada = carro.hora_entrada
      hora_saida = carro.hora_saida
      total_a_pagar_por_veiculo = "%.2f" % carro.total_a_pagar_por_veiculo
      subtotais_acumulado_str = "%.2f" % carro.subtotais_acumulado

      puts format_string % [placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida, total_a_pagar_por_veiculo, subtotais_acumulado_str]
      #debugger
    end

    puts "======================================================================================================================================================================"
    CadastramentoVeiculo.volta_menu
  end

  def self.deletar
    system 'clear'
    puts "+-------------------------------------------------------------+"
    puts "|Você escolheu a opção (5) para deletar um registro de veículo|"
    puts "+-------------------------------------------------------------+\n\n"
    print "Entre com a placa do registro que você quer excluir: "
    placa = gets.chomp
    CadastramentoVeiculo.mostrar_entrada_saida(placa, @@veiculos[placa][:carro].nome_veiculo, @@veiculos[placa][:carro].dono_do_veiculo, @@veiculos[placa][:carro].hora_entrada, @@veiculos[placa][:carro].hora_saida, @@veiculos[placa][:carro].total_a_pagar_por_veiculo)
    puts "Tem certeza que deseja excluir o registro acima? (S/N)."
    escolha = gets.upcase.chomp
    if escolha == "N"
      CadastramentoVeiculo.menu
    elsif escolha == "S"
      @@veiculos.delete(placa)
    else
      while escolha != "N" && escolha != "S"
        puts "Só é admitido nessa etapa os valores (N) ou (S)."
        escolha= gets.upcase.chomp
      end
    end
  end
    def self.editar_veiculo
      puts "+-------------------------------------------------------------+"
      puts "|Você escolheu a opção (6) para editar um registro de veículo.|"
      puts "+-------------------------------------------------------------+\n\n"
      print "Digite o número da placa do carro que você quer editar: "
      placa = gets.chomp
      #debugger
      CadastramentoVeiculo.mostrar_entrada_saida(placa, @@veiculos[placa][:carro].nome_veiculo, @@veiculos[placa][:carro].dono_do_veiculo, @@veiculos[placa][:carro].hora_entrada, @@veiculos[placa][:carro].hora_saida, @@veiculos[placa][:carro].total_a_pagar_por_veiculo)
      puts "Tem certeza que deseja editar o registro acima? (S/N)."
      escolha = gets.upcase.chomp
      if escolha == "N"
        CadastramentoVeiculo.menu
      elsif escolha == "S"
        system 'clear'
        print "Mantenha ou digite a nova placa do veículo: "
        @@veiculos[placa][:carro].placa = gets.chomp
        print "Mantenha ou digite o novo nome do veículo: "
        @@veiculos[placa][:carro].nome_veiculo = gets.chomp
        print "Mantenha ou digite o novo nome do dono do veículo: "
        @@veiculos[placa][:carro].dono_do_veiculo = gets.chomp
        print "Mantenha ou digite a nova hora da entrada do veículo: "
        @@veiculos[placa][:carro].hora_entrada = gets.chomp
        print "Mantenha ou digite a nova hora de saída do veículo: "
        @@veiculos[placa][:carro].hora_saida = gets.chomp
        ControleVeiculos.calculo(placa, @@veiculos[placa][:carro].hora_entrada, @@veiculos[placa][:carro].hora_saida)

      else
        while escolha != "N" && escolha != "S"
          puts "Só é admitido nessa etapa os valores (N) ou (S)."
          escolha= gets.upcase.chomp
        end
      end

    end

end

CadastramentoVeiculo.init
