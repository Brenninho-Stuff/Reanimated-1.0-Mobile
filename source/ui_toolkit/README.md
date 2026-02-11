# UI Toolkit (Juicy UI)

Un módulo de UI reutilizable y "Juicy" para HaxeFlixel, diseñado para ser copiado y pegado entre proyectos.

## Contenido

1.  **UIAnimator.hx**: Clase estática con helpers de animación (Tweening) para dar vida a la interfaz.
2.  **JuicyButton.hx**: Botón prefabricado con estados (Hover, Click) y animaciones automáticas.

## Instalación

Simplemente copia la carpeta `ui_toolkit` dentro de la carpeta `source` de tu proyecto HaxeFlixel.

Asegúrate de que tu `Project.xml` incluya `flixel` (que es el estándar).

## Uso

### 1. Importar

```haxe
import ui_toolkit.UIAnimator;
import ui_toolkit.JuicyButton;
```

### 2. Crear un Botón "Juicy"

```haxe
// En tu State (ej. PlayState.hx o MenuState.hx)

override public function create():Void
{
    super.create();

    // Crear un botón simple
    var btn = new JuicyButton(0, 0, "¡Púlsame!", function() {
        trace("¡Botón pulsado!");
        // Ejemplo de animación extra al pulsar
        FlxG.camera.shake(0.01, 0.1);
    });
    
    // Centrar en pantalla
    btn.screenCenter();
    
    // Añadir al estado
    add(btn);
}
```

### 3. Usar UIAnimator manualmente

Puedes usar `UIAnimator` para animar cualquier `FlxSprite` o `FlxGroup`.

```haxe
var miSprite = new FlxSprite(100, 100).makeGraphic(50, 50, FlxColor.RED);
add(miSprite);

// Animación de entrada (Pop In)
UIAnimator.popIn(miSprite);

// Animación de "latido" (Pulse)
// UIAnimator.pulse(miSprite);

// Animación de sacudida (Shake) para errores
// UIAnimator.shake(miSprite);

// Animación de entrada deslizante (Slide In)
// UIAnimator.slideIn(miSprite, -200, 0); // Viene desde 200px a la izquierda
```

## Personalización

Puedes ajustar los colores y escalas del botón directamente:

```haxe
var btn = new JuicyButton(0, 0, "Jugar");
btn.normalColor = 0xFF00FF00; // Verde
btn.hoverColor = 0xFF00CC00;
btn.clickColor = 0xFF005500;
add(btn);
```

¡Disfruta de tu UI jugosa!
