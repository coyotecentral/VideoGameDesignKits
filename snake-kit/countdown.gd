extends CanvasLayer

signal done

func animation_finished():
	done.emit()
	
