#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Если Ссылка=ПредопределенноеЗначение("Справочник.ЭтапыПроизводства.ЗавершениеПроизводства") И ПометкаУдаления Тогда
		ПометкаУдаления = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли