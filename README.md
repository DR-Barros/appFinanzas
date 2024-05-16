# app_finanzas

App Finanzas es una aplicación móvil diseñada para ayudar a los usuarios a gestionar sus finanzas personales. La aplicación sigue el modelo Vista Controlador y está estructurada en cuatro modelos principales. Este proyecto se creó con el propósito de aprender y practicar el proceso de subir aplicaciones a la Play Store.

## Características

* **Gestión de Cuentas:** Permite a los usuarios agregar cuentas de diferentes tipos (ahorro, corriente, crédito).
* **Transacciones:** Los usuarios pueden registrar y visualizar sus ingresos y gastos, categorizados por tipo y fecha.
* **Planificación Financiera:** Ofrece una herramienta de planificación para gestionar ingresos y gastos mensuales, con la capacidad de crear, editar y visualizar elementos de planificación.
* **Interfaz de Usuario Intuitiva:** Diseño amigable con navegación fácil a través de una barra de navegación inferior.

## Instalación
Puedes descargar la aplicación desde la Play Store a través del siguiente [enlace](https://play.google.com/store/apps/details?id=com.app_finanzas).

## Uso
###  Pantallas Principales
1. **Ingresos:** Permite registrar y visualizar los ingresos.
2. **Gastos:** Permite registrar y visualizar los gastos.
3. **Planificación:** Permite gestionar la planificación financiera mensual.
4. **Cuentas:** Permite gestionar las cuentas financieras.
5. **Usuario:** Información y configuración del usuario.

### Navegación
La aplicación utiliza una barra de navegación inferior para acceder fácilmente a las diferentes secciones mencionadas.

## Estructura del Proyecto
El proyecto sigue el patrón de diseño Modelo Vista Controlador (MVC):

* Modelos:

    * User: Representa al usuario y contiene información personal, cuentas, transacciones y planificación.
    * Account: Representa una cuenta financiera del usuario.
    * Transaction: Representa una transacción financiera (ingreso o gasto).
    * Planning: Representa la planificación financiera mensual.
* Vistas: Componentes de la interfaz de usuario que muestran la información y permiten la interacción del usuario.

* Controladores: Manejan la lógica de la aplicación, gestionando la interacción entre las vistas y los modelos.

## Licencia
Este proyecto está bajo la Licencia MIT. Para más detalles, consulta el archivo [LICENSE](LICENSE).