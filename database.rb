require 'pg'
require 'byebug'

class Database
  def cadastrar_entrada

  end
  def self.delete_veiculo_pela_placa
    system 'clear'
    print "Digite a placa do veículo que deseja excluir: "
    #debugger
    placa = gets.chomp

    conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')

    result = conn.exec_params("SELECT * FROM estacionamento.controle_veiculos WHERE placa = $1", [placa])

    if result.num_tuples == 0
      puts "Placa não encontrada no banco de dados."
    else
      system 'clear'
      puts "+-----------------------+"
      puts "|Veículo a ser excluído:|"
      puts "+-----------------------+"
      puts "Placa: #{result[0]['placa']}"
      puts "Nome do veículo: #{result[0]['nome_veiculo']}"
      puts "Dono do veículo: #{result[0]['dono_do_veiculo']}"
      puts "Hora de entrada: #{result[0]['hora_entrada']}"
      puts "Hora de saída: #{result[0]['hora_saida']}"
      puts "Total a pagar: R$ #{result[0]['total_a_pagar']}"
      puts "+--------------------------------------------------------+"
      puts "|Confirma exclusão do veículo com placa #{placa}? (S/N)  |"
      puts "+--------------------------------------------------------+"
      confirmacao = gets.chomp.downcase
      if confirmacao == "s"
        conn.exec_params("DELETE FROM estacionamento.controle_veiculos WHERE placa = $1", [placa])
        system 'clear'
        puts "+------------------------------+"
        puts "| Veículo deletado com sucesso!|"
        puts "+------------------------------+"
      else
        puts "+--------------------------------------------+"
        puts "|Operação de exclusão cancelada pelo usuário.|"
        puts "+--------------------------------------------+"
      end
    end


  end

  def self.relatorio_veiculos
    system 'clear'
    begin
      conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
      result = conn.exec("SELECT * FROM estacionamento.controle_veiculos;")
      puts "+----------------------------------------------------------| Relatório dos veículos registrados até o momento |----------------------------------------------------------------------------+\n|"
      result.each do |row|
        puts "| Placa: #{row['placa']}, Nome do veículo: #{row['nome_veiculo']}, Dono do veículo: #{row['dono_do_veiculo']}, Hora de entrada: #{row['hora_entrada']}, Hora de saída: #{row['hora_saida']}, Total a pagar: R$ #{'%.2f' % row['total_a_pagar'].to_f}"

      end
      puts "+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
    rescue PG::Error => e
      puts e.message
    ensure
      conn.close unless conn.nil?
    end

  end

  def self.inserir_veiculo
    system 'clear'
    print "Informe a placa do veículo: "
    placa = gets.chomp
    print "Informe o nome do veículo: "
    nome_veiculo = gets.chomp
    print "Informe o nome do dono do veículo: "
    dono_do_veiculo = gets.chomp
    print "Informe a hora de entrada do veículo no formato hh:mm: "
    hora_entrada = gets.chomp
    if hora_entrada.nil?
      # Se hora_entrada for nil, mostre uma mensagem de erro e retorne sem fazer nada
      print "Erro: hora de entrada inválida"
      return
    end

    hora_entrada = Time.strptime(hora_entrada, "%H:%M")

    begin
        conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
        conn.exec_params("INSERT INTO estacionamento.controle_veiculos (placa, nome_veiculo, dono_do_veiculo, hora_entrada) VALUES ($1, $2, $3, $4)", [placa, nome_veiculo, dono_do_veiculo, hora_entrada])
      rescue PG::Error => e
        puts e.message
      ensure
        conn.close unless conn.nil?
      end
  end

  def self.edit_veiculo(placa, nome_veiculo, dono_do_veiculo, hora_entrada)
    system 'clear'
    begin
      conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
      conn.exec_params("UPDATE estacionamento.controle_veiculos SET nome_veiculo=$1, dono_do_veiculo=$2, hora_entrada=$3 WHERE placa=$4", [nome_veiculo, dono_do_veiculo, hora_entrada, placa])
    rescue PG::Error => e
      puts e.message
    ensure
      conn.close unless conn.nil?
    end
  end

  def self.registrar_saida(placa, hora_saida)
    connection = PG.connect(host: 'localhost', dbname: 'estacionamento', user: 'postgres', password: 'Joacira')
    placa_existente = connection.exec_params("SELECT * FROM estacionamento.controle_veiculos WHERE placa = $1", [placa])
    if placa_existente.num_tuples == 0
      puts "Placa não encontrada no banco de dados."
      return nil
    end
    connection.prepare('select_veiculo', 'SELECT placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida, total_a_pagar FROM estacionamento.controle_veiculos WHERE placa = $1')
    result = connection.exec_prepared('select_veiculo', [placa])
    puts "Veículo encontrado:"
      puts "Placa: #{result[0]['placa']}"
      puts "Nome do veículo: #{result[0]['nome_veiculo']}"
      puts "Dono do veículo: #{result[0]['dono_do_veiculo']}"
      puts "Hora de entrada: #{result[0]['hora_entrada']}"
      puts "Hora de saída: #{hora_saida}"
      total_a_pagar = (Time.parse(hora_saida) - Time.parse(result[0]['hora_entrada'])) / 60 * 0.17
      puts "Total a pagar: R$ #{total_a_pagar.round(2)}"
      connection.prepare('update_saida', 'UPDATE estacionamento.controle_veiculos SET hora_saida = $1, total_a_pagar = $2 WHERE placa = $3 RETURNING *')
      result = connection.exec_prepared('update_saida', [hora_saida, total_a_pagar, placa])
      puts "+------------------------------+"
      puts "| Saída registrada com sucesso! |"
      puts "+------------------------------+"
      puts "Veículo atualizado:"
      puts "Placa: #{result.first['placa']}"
      puts "Nome do veículo: #{result.first['nome_veiculo']}"
      puts "Dono do veículo: #{result.first['dono_do_veiculo']}"
      puts "Hora de entrada: #{result.first['hora_entrada']}"
      puts "Hora de saída: #{result.first['hora_saida']}"
      puts "Total a pagar: R$ #{result.first['total_a_pagar']}"
    connection.close
  end

  def self.buscar_veiculo
    system 'clear'
    puts "\n|----- Voce escolheu a opção: (3)BUSCAR VEÍCULO POR PLACA -----|\n\n"
    print "Digite a placa do veículo: "
    placa = gets.strip
    connection = PG.connect(host: 'localhost', dbname: 'estacionamento', user: 'postgres', password: 'Joacira')
    connection.prepare('select_veiculo', 'SELECT placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida, total_a_pagar FROM estacionamento.controle_veiculos WHERE placa = $1')
    result = connection.exec_prepared('select_veiculo', [placa])

    if result.count == 0
      puts "Nenhum veículo encontrado com a placa #{placa}"
    else
      puts "+-------------------------+"
      puts "|   Veículo encontrado:   |"
      puts "+-------------------------+\n\n"
      puts "Placa: #{result[0]['placa']}"
      puts "Nome do veículo: #{result[0]['nome_veiculo']}"
      puts "Dono do veículo: #{result[0]['dono_do_veiculo']}"
      puts "Hora de entrada: #{result[0]['hora_entrada']}"
      puts "Hora de saída: #{result[0]['hora_saida']}"
      puts "Total a pagar: R$ #{result[0]['total_a_pagar']}"
    end
    connection.close
  end

end