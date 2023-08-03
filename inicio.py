from flask import Flask
from flask import render_template ,request, redirect, session
from flaskext.mysql import MySQL
from datetime import datetime
from flask import send_from_directory
import os

app=Flask(__name__)
app.secret_key="camilo"
mysql=MySQL()

app.config['MYSQL_DATABASE_HOST']='localhost'
app.config['MYSQL_DATABASE_USER']='root'
app.config['MYSQL_DATABASE_PASSWORD']=''
app.config['MYSQL_DATABASE_DB']='inexpress'
mysql.init_app(app)

@app.route('/')
def ini():
    return render_template('site/index.html')

@app.route('/img/<imagen>')
def imagenes(imagen):
    imagen_nombre = imagen[2:-1]  # Eliminar el prefijo b'' de la imagen
    print(imagen_nombre)
    return send_from_directory(os.path.join('templates/site/img'), imagen_nombre)

@app.route('/productos')
def productos():
    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('SELECT * FROM productos')
    productos=cursor.fetchall()
    conexion.commit()
    print(productos)
    return render_template('site/productos.html', productos=productos)

@app.route('/nosotros')
def nosotros():
    return render_template('site/nosotros.html')

@app.route('/admin/')
def admin_index():
    if not 'login' in session:
        return redirect("/admin/login")
    
    return render_template('admin/index.html')

@app.route('/admin/login')
def admin_login():
    return render_template('admin/login.html')
@app.route('/admin/login' , methods=['post'])
def admin_login_post():
    usuario=request.form['txtusuario']
    contrasena=request.form['txtpassword']
    print(usuario,contrasena)

    if usuario=="administrador" and contrasena=="12345678":
        session["login"]=True
        session["usuario"]="camilo"
        return redirect("/admin")
    return render_template("admin/login.html")

@app.route('/admin/cerrar')
def admin_login_cerrar():
    session.clear()
    return redirect('/admin/login')

#crud productos
@app.route('/admin/productos')
def admin_productos():
    if not 'login' in session:
        return redirect("/admin/login")
    
    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('SELECT * FROM productos')
    productos=cursor.fetchall()
    conexion.commit()
    print(productos)
    return render_template('admin/productos.html', productos=productos)


@app.route('/admin/productos/guardar', methods=['POST'])
def admin_productos_guardar():

    if not 'login' in session:
        return redirect("/admin/login")
    
    id_=request.form['txtid']
    nombre_=request.form['txtnomprod']
    valor_=request.form['txtvalor']
    descripcion_=request.form['txtdescripcion']
    stock_=request.form['txtstock']
    idmarca_=request.form['txtidmarca']
    idclase_=request.form['txtidclase']
    imagen_=request.files['txtimagen']

    tiempo=datetime.now()
    horaActual=tiempo.strftime('%Y%H%M%S')

    if imagen_.filename!="":
        nuevoNombre=horaActual+"_"+imagen_.filename
        imagen_.save("templates/site/img/"+nuevoNombre)
        print(horaActual)
        print(imagen_.filename)

    sql="INSERT INTO `productos` (`idprod`, `nombreprod`, `valorprod`, `descripcion`, `cantidadprod`, `idmarca`, `idclass`, `imagen`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    datos=(id_,nombre_,valor_,descripcion_,stock_,idmarca_,idclase_,nuevoNombre)

    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute(sql,datos)
    conexion.commit()
    print(imagen_.filename)

    return redirect('/admin/productos')

@app.route('/admin/productos/borrar', methods=['post'])
def admin_productos_borrar():
    if not 'login' in session:
        return redirect("/admin/login")
    
    id_=request.form['txtid']
    print(id_)

    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('SELECT imagen FROM productos WHERE idprod=%s',(id_))
    productos=cursor.fetchall()
    conexion.commit()
    print(productos)

    if os.path.exists("templates/site/img/"+str(productos[0][0])):
        os.unlink("templates/site/img/"+str(productos[0][0]))

    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('DELETE FROM productos WHERE idprod=%s',(id_))
    conexion.commit()

    return redirect('/admin/productos')
@app.route('/admin/productos/actualizar', methods=['post'])
def admin_productos_actualizar():
    if not 'login' in session:
        return redirect("admin/login")
    id_=request.form['txtid']
    print(id_)
    
    conexion=mysql.connect()
    cursor=conexion.cursor()
    
    cursor.execute('SELECT * FROM productos WHERE idprod=%s',(id_))
    productos=cursor.fetchall()
    conexion.commit()
    print(productos)

    return render_template('/admin/actualizarprod.html',productos=productos)
    

@app.route('/admin/actualizar', methods=['POST'])
def admin_actualizarprod():
    if not 'login' in session:
        return redirect("admin/login")
    
    id_=request.form['txtid']
    nombre_=request.form['txtnomprod']
    valor_=request.form['txtvalor']
    descripcion_=request.form['txtdescripcion']
    stock_=request.form['txtstock']
    idmarca_=request.form['txtidmarca']
    idclase_=request.form['txtidclase']
    imagen_=request.files['txtimagen']


    sql = "UPDATE productos SET idprod=%s, nombreprod=%s, valorprod=%s, descripcion=%s, cantidadprod=%s, idmarca=%s, idclass=%s, imagen=%s WHERE idprod=%s"
    datos = (id_, nombre_, valor_, descripcion_, stock_, idmarca_, idclase_, imagen_.filename, id_)  # Asumiendo que 'imagen_.filename' es el nombre de la imagen que quieres actualizar en la base de datos.

    conexion = mysql.connect()
    cursor = conexion.cursor()
    cursor.execute(sql, datos)
    conexion.commit()
    print(imagen_.filename)

    return redirect('/admin/productos')
#crud usuarios

@app.route('/admin/usuarios')
def admin_usuarios():
    if not 'login' in session:
        return redirect("/admin/login")
    
    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('SELECT * FROM usuarios')
    usuarios=cursor.fetchall()
    conexion.commit()
    return render_template('admin/usuarios.html', usuarios=usuarios)


@app.route('/admin/usuarios/guardar', methods=['POST'])
def admin_usuarios_guardar():

    if not 'login' in session:
        return redirect("/admin/login")
    
    id_=request.form['txtid']
    nombre_=request.form['txtnomusu']
    rol_=request.form['txtrolusuario']
    contrasena_=request.form['txtcontrasena']

    sql="INSERT INTO `usuarios` (`idusuario`, `nombreusuario`, `rolusuario`, `contraseña`) VALUES (%s, %s, %s, %s)"
    datos=(id_,nombre_,rol_,contrasena_)

    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute(sql,datos)
    conexion.commit()


    return redirect('/admin/usuarios')

@app.route('/admin/usuarios/actualizar', methods=['post'])
def admin_usuarios_actualizar():
    if not 'login' in session:
        return redirect("admin/login")
    id_=request.form['txtid']
    print(id_)
    
    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('SELECT * FROM usuarios WHERE idusuario=%s',(id_))
    usuarios=cursor.fetchall()
    conexion.commit()
    print(productos)

    return render_template('/admin/actualizarusuario.html',usuarios=usuarios)
    

@app.route('/admin/actualizarusu', methods=['POST'])
def admin_actualizarusu():
    if not 'login' in session:
        return redirect("admin/login")
    
    id_=request.form['txtid']
    nombre_=request.form['txtnomusu']
    rol_=request.form['txtrolusuario']
    contrasena_=request.form['txtcontrasena']
    


    sql = "UPDATE `usuarios` SET `idusuario`=%s,`nombreusuario`=%s,`rolusuario`=%s,`contraseña`=%s WHERE `idusuario`=%s"
    datos = (id_, nombre_, rol_, contrasena_,id_)

    conexion = mysql.connect()
    cursor = conexion.cursor()
    cursor.execute(sql, datos)
    conexion.commit()


    return redirect('/admin/usuarios')

@app.route('/admin/usuarios/borrar', methods=['post'])
def admin_usuarios_borrar():
    if not 'login' in session:
        return redirect("/admin/login")
    
    id_=request.form['txtid']
    print(id_)
    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('DELETE FROM usuarios WHERE idusuario=%s',(id_))
    conexion.commit()

    return redirect('/admin/usuarios')
#crud marcas
@app.route('/admin/marcas')
def admin_marcas():
    if not 'login' in session:
        return redirect("/admin/login")
    
    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('SELECT * FROM marcaprod')
    marcas=cursor.fetchall()
    conexion.commit()
    return render_template('admin/marcas.html', marcas=marcas)


@app.route('/admin/marcas/guardar', methods=['POST'])
def admin_marcas_guardar():

    if not 'login' in session:
        return redirect("/admin/login")
    
    id_=request.form['txtid']
    marca_=request.form['txtnommarca']

    sql="INSERT INTO `marcaprod`(`idmarca`, `marca`) VALUES (%s,%s)"
    datos=(id_,marca_)

    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute(sql,datos)
    conexion.commit()


    return redirect('/admin/marcas')

@app.route('/admin/marcas/actualizar', methods=['post'])
def admin_marcas_actualizar():
    if not 'login' in session:
        return redirect("admin/login")
    id_=request.form['txtid']
    print(id_)
    
    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('SELECT * FROM marcaprod WHERE idmarca=%s',(id_))
    marcas=cursor.fetchall()
    conexion.commit()
    

    return render_template('/admin/actualizarmarca.html',marcas=marcas)
    

@app.route('/admin/actualizarmarca', methods=['POST'])
def admin_actualizarmarca():
    if not 'login' in session:
        return redirect("admin/login")
    
    id_=request.form['txtid']
    nombre_=request.form['txtnommarca']

    sql = "UPDATE `marcaprod` SET `idmarca`=%s,`marca`=%s WHERE idmarca=%s"
    datos = (id_, nombre_,id_)

    conexion = mysql.connect()
    cursor = conexion.cursor()
    cursor.execute(sql, datos)
    conexion.commit()


    return redirect('/admin/marcas')

@app.route('/admin/marcas/borrar', methods=['post'])
def admin_marcas_borrar():
    if not 'login' in session:
        return redirect("/admin/login")
    
    id_=request.form['txtid']
    print(id_)
    conexion=mysql.connect()
    cursor=conexion.cursor()
    cursor.execute('DELETE FROM marcaprod WHERE idmarca=%s',(id_))
    conexion.commit()

    return redirect('/admin/usuarios')

   
if __name__ =='__main__':
    app.run(debug=True)