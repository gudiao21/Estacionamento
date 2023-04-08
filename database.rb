require 'pg'

class Database
  def initialize
    @conn = PG.connect(dbname: 'estacionamento')
  end

  def insert(registro)
    @conn.exec_params('INSERT INTO registros (campo1, campo2, campo3) VALUES ($1, $2, $3)', [registro[:campo1], registro[:campo2], registro[:campo3]])
  end

  def delete(id)
    @conn.exec_params('DELETE FROM registros WHERE id = $1', [id])
  end

  def update(id, registro)
    @conn.exec_params('UPDATE registros SET campo1 = $1, campo2 = $2, campo3 = $3 WHERE id = $4', [registro[:campo1], registro[:campo2], registro[:campo3], id])
  end

  def select_all
    @conn.exec('SELECT * FROM registros ORDER BY id')
  end

  def select(id)
    @conn.exec_params('SELECT * FROM registros WHERE id = $1', [id])
  end

  def close
    @conn.close
  end
end
