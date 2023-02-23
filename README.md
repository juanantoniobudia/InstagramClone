# InstagramClone
Aplicación que permite visualizar y dar "likes" a imágenes.
He utilizado las siguientes tecnologías en las diferentes partes:
- Los servicios de Firebase Authentication para el control de usuarios(registro/acceso). 
- Firebase Storage para almacenar las imágenes en la nube y Firebase Firestore para almacenar en un dicionario llamado "Posts" con información a guardar con los siquientes campos clave (url de cada imagen, 
usuario de la aplicación que guarda la información, la fecha, el nombre del archivo y los likes) 
- El acceso a Firebase Firestore para leer la informacion de todos los post y ademas poder modificar el campo likes incrementandolo. En esta vista pinto la 
informacion con una tableview que contiene las celdas personalizadas FeedCell y uso la librería SDWebImage cargada a través del fichero de pods para cargar las imágenes a través de la url.
- La otra parte es el sign out de firebase que te lleva a la primera vista de la aplicación. 
Para navegar entre las diferentes vistas he usado la navegación a través de una Tab Bar.
Para vincular mi aplicación a Firebase elegí el gestor de dependencias CocoaPods incluyendo además librerías que me permitan ver las analiticas de la
aplicación en la consola de Firebase. 

He añadido un archivo .m4v con una demostración del funcionamiento.
