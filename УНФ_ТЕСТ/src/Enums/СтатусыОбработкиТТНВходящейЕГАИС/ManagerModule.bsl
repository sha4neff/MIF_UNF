#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ЗначенияПеречисления Цикл
		Если Лев(ЗначениеПеречисления.Имя, СтрДлина("Удалить")) <> "Удалить" Тогда
			ДанныеВыбора.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС[ЗначениеПеречисления.Имя]);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
