extends CanvasLayer

signal done

func animation_finshed():
	done.emit()
