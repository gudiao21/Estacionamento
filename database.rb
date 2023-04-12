require 'pg'
require_relative 'estacionamento'

class Database

  def self.delete_veiculo(placa)
    system 'clear'
    begin
      conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
      conn.exec_params("DELETE FROM estacionamento.controle_veiculos WHERE placa = '#{placa}'")
    rescue PG::Error => e
      puts e.message
    ensure
      conn.close unless conn.nil?
    end
    print "=========================================================="
    print "Veículo de placa #{placa} foi excluído com sucesso!"
    print "=========================================================="
  end

  def self.relatorio_veiculos
    system 'clear'
    begin
      conn = PG.connect(dbname: 'estacionamento', user: 'postgres', password: 'Joacira', host: 'localhost', port: '5432')
      result = conn.exec("SELECT * FROM estacionamento.controle_veiculos;")
      puts "+----------------------------------------------------------| Relatório dos veículos registrados até o momento |----------------------------------------------------------------------------+\n|"
      result.each do |row|
        puts "|                     Placa: #{row['placa']}, Nome do veículo: #{row['nome_veiculo']}, Dono do veículo: #{row['dono_do_veiculo']}, Hora de entrada: #{row['hora_entrada']}, Hora de saída: #{row['hora_saida']}"
      end
      puts "+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
    rescue PG::Error => e
      puts e.message
    ensure
      conn.close unless conn.nil?
    end
    ControleVeiculos.volta_menu
  end

  def self.inserir_veiculo(placa, nome_veiculo, dono_do_veiculo, hora_entrada)
    system 'clear'
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
    system 'clear'
    connection = PG.connect(host: 'localhost', dbname: 'estacionamento', user: 'postgres', password: 'Joacira')
    connection.prepare('update_saida', 'UPDATE estacionamento.controle_veiculos SET hora_saida = $1 WHERE placa = $2')
    result = connection.exec_prepared('update_saida', [hora_saida, placa])
    connection.close
  end

  def self.buscar_veiculo(placa)
    connection = PG.connect(host: 'localhost', dbname: 'estacionamento', user: 'postgres', password: 'Joacira')
    connection.prepare('select_veiculo', 'SELECT placa, nome_veiculo, dono_do_veiculo, hora_entrada, hora_saida FROM estacionamento.controle_veiculos WHERE placa = $1')
    result = connection.exec_prepared('select_veiculo', [placa])

    if result.ntuples == 0
      puts "Veículo não encontrado."
    else
      result.each do |row|
        puts "Placa: #{row['placa']}"
        puts "Nome do veículo: #{row['nome_veiculo']}"
        puts "Dono do veículo: #{row['dono_do_veiculo']}"
        puts "Hora de entrada: #{row['hora_entrada']}"
        puts "Hora de saída: #{row['hora_saida'] || 'N/A'}"
      end
    end

    connection.close
  end

end