#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Организация = Параметры.Организация;
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Организация", Организация,
			ЗначениеЗаполнено(Организация));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
