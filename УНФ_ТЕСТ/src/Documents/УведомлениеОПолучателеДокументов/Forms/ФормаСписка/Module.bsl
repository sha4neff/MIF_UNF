
#Область ОбработчикиСобытий

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_УведомлениеОПолучателеДокументов", , Элемент.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

