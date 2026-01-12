# classlog

> Student learning tracker for attendance, grades,
> and course management

Un sistema de seguimiento académico para estudiantes.

# Aprendizajes del Proceso de Desarrollo

Por primera vez, he creado una aplicación Flutter que se comunica con un backend a través de la API de FacturaScripts, integrando múltiples pantallas.

Inicialmente, planifiqué crear una aplicación para que los estudiantes gestionaran su asistencia, exámenes, entregas de tareas y otros estados. Después de esbozar las funcionalidades y diseñar la interfaz, comencé el desarrollo. Sin embargo, mientras trabajaba, surgieron decisiones como "esta función no es esencial, la agregaré después" o "sería bueno tener esto", lo que hizo que el plan inicial se desviara. Con el tiempo, perdí la visión general del proyecto y terminé trabajando de manera improvisada, resultando en código innecesariamente extenso y complejo.

Por ejemplo, inicialmente pasaba el estado entre widgets, pero a medida que aumentaron las pantallas y las solicitudes repetidas del ID de usuario, decidí refactorizar usando Riverpod, lo que consumió mucho tiempo. Además, al implementar el dashboard antes que el login, la API se volvió inestable. Hacia el final, solo me enfocaba en resolver errores inmediatos. A través de esta experiencia aprendí que **no invertir suficiente tiempo en la fase de diseño antes de codificar resulta en costos mucho mayores después**.

Debo admitir que, debido a circunstancias personales y falta de tiempo disponible, habría sido imposible completar este proyecto sin utilizar IA. Dependí bastante de ella en muchas partes. Sin embargo, al analizar el código repetidamente, pude aprender aspectos importantes como:

- El flujo completo de funcionamiento de la aplicación
- El uso de dependencias y widgets que desconocía anteriormente
- Cómo instalar un backend en un servidor de hosting real (Hostinger) e integrarlo mediante API
- Cómo separar y almacenar el estado, compartiendo datos entre widgets en la jerarquía inferior
- El uso de almacenamiento local
- Cómo compilar la aplicación para web, probarla y desplegarla en GitHub, entre otros

Considero que el valor real de este proyecto no radica tanto en la calidad del producto final, sino en el **proceso de aprendizaje y la comprensión de cómo hacer mejor las cosas en el futuro**.
