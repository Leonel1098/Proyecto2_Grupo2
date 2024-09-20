from flask import Flask, render_template, request, redirect, url_for
import pyodbc

app = Flask(__name__)

# Conexión a MSSQL
def get_db_connection():
    conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=LEONEL;DATABASE=GestiondeReservaciones;UID=Leonel;PWD=Leonel')
    return conn

# Crear cliente (POST)
@app.route('/', methods=['GET', 'POST'])
def crear_cliente():
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        email = request.form['email']
        telefono = request.form['telefono']
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("EXEC sp_CrearCliente @Nombre=?, @Apellido=?, @Email=?, @Telefono=?", (nombre, apellido, email, telefono))
        conn.commit()
        cursor.close()
        conn.close()
        
        # Redirigir después de la creación sin flash
        return redirect(url_for('listar_clientes'))
    
    return render_template('Crear_Cliente.html')

# Listar todos los clientes
@app.route('/clientes')
def listar_clientes():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("EXEC sp_ObtenerClientes")
    clientes = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return render_template('listar_clientes.html', clientes=clientes)

# Actualizar cliente (GET y POST)
@app.route('/clientes/editar/<int:cliente_id>', methods=['GET', 'POST'])
def editar_cliente(cliente_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        email = request.form['email']
        telefono = request.form['telefono']
        
        cursor.execute("EXEC sp_ActualizarCliente @ClienteID=?, @Nombre=?, @Apellido=?, @Email=?, @Telefono=?", (cliente_id, nombre, apellido, email, telefono))
        conn.commit()
        cursor.close()
        conn.close()
        
        return redirect(url_for('listar_clientes'))
    
    # Obtener los datos actuales del cliente
    cursor.execute("SELECT * FROM Clientes WHERE cliente_id = ?", (cliente_id,))
    cliente = cursor.fetchone()
    cursor.close()
    conn.close()
    
    return render_template('Editar_Cliente.html', cliente=cliente)

# Eliminar cliente (POST)
@app.route('/clientes/eliminar/<int:cliente_id>', methods=['POST'])
def eliminar_cliente(cliente_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("EXEC sp_EliminarCliente @ClienteID=?", (cliente_id,))
    conn.commit()
    cursor.close()
    conn.close()
    
    return redirect(url_for('listar_clientes'))

if __name__ == '__main__':
    app.run(debug=True)
