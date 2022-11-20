#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// ОбменДанными.Загрузка не требуется.
	// Запрещаем изменять набор записей для неразделенных узлов из разделенного режима.
	ОбменДаннымиСервер.ВыполнитьКонтрольЗаписиНеразделенныхДанных(Отбор.УзелИнформационнойБазы.Значение);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли