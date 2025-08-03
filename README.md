# 🕵️‍♂️ Base de Datos Criminal con SWI-Prolog y Front-End

Este proyecto utiliza **SWI-Prolog** como base de datos lógica para modelar y consultar información relacionada con:

- Jerarquías dentro de organizaciones criminales  
- Afiliaciones a cárteles  
- Actividades delictivas  
- Relaciones de complicidad  
- Historial de arrestos  
- Rivalidades entre grupos  

Una interfaz web permite realizar consultas fácilmente desde un navegador.

---

## 🚀 Cómo usar el proyecto

### 1. Clona el repositorio
git clone https://github.com/forgar18/Red-Criminal-Swi-Prolog-con-front-end.git

cd tu_repositorio

Abre tu terminal dentro del directorio del proyecto y ejecuta:
swipl

Luego, dentro del intérprete de Prolog:
consult('server.pl').

Si todo está bien, verás algo como:
% Started server at http://localhost:8080/
true.
✅ Esto significa que el servidor está escuchando correctamente en el puerto 8080.

Abre el archivo index.html en tu navegador para comenzar a realizar consultas visualmente.

Puedes hacerlo con doble clic o ejecutando en terminal (dependiendo del sistema operativo):
start index.html          # En Windows
xdg-open index.html       # En Linux
open index.html           # En macOS


🛠 Tecnologías utilizadas

💡 SWI-Prolog — Base de datos lógica y servidor HTTP

🌐 HTML y CSS — Interfaz web

🔄 Comunicación entre front-end y Prolog a través de peticiones HTTP

📂 Estructura del proyecto
proyecto/
├── fonts/
│   ├── amerita.otf
│   ├── apple.ttf
│   └── glit.otf
└── index.html
