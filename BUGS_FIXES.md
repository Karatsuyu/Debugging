Resumen de Bugs y Correcciones - Contador de Visitas

Bug 1
- Síntoma: El contador no incrementa al abrir la app (permanece en el mismo número).
- Causa: En `lib/main.dart` se sumaba `+ 0` en lugar de `+ 1` al leer el valor.
- Solución: Cambiar `contadorGuardado = contadorGuardado + 0;` por `contadorGuardado = contadorGuardado + 1;` y guardar inmediatamente.

Bug 2
- Síntoma: El valor no se persiste correctamente entre cierres y aperturas.
- Causa: El guardado se hacía en `dispose()` llamando a una función `async` sin `await`, por lo que la app se cerraba antes de completar el guardado.
- Solución: Guardar el valor inmediatamente después de incrementar (usar `await prefs.setInt(...)`) y eliminar el guardado no-await en `dispose()`.

Bug 3
- Síntoma: Después de reiniciar el contador, el valor no se preserva correctamente tras cerrar y abrir.
- Causa: El reinicio usaba `prefs.setInt('contador', 0)` sin `await`, por lo que el guardado podía no completarse antes del cierre.
- Solución: Añadir `await` en el guardado dentro de `_reiniciarContador()` (y en `_guardarContador()`), garantizando que la operación asíncrona se complete.

Cómo reproducir
1. Ejecutar `flutter run`.
2. Observar el número mostrado.
3. Cerrar la app completamente y volver a abrir: el número debe incrementarse en 1 cada vez.
4. Pulsar "Reiniciar Contador": debe mostrar 0; al volver a abrir debe pasar a 1.

Ramas en el repositorio remoto
- `main`: contiene la versión original (con bugs).
- `fix/corregir-contador`: contiene la versión corregida con las modificaciones descritas.

Archivos modificados
- `lib/main.dart` (correcciones aplicadas en la rama `fix/corregir-contador`).

Si quieres, puedo:
- Crear un Pull Request desde `fix/corregir-contador` a `main`.
- Ejecutar `flutter analyze` y `flutter run` aquí (si confirmas que quieres que lo haga).
