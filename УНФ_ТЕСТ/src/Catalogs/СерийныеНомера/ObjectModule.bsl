#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытийФормы

Процедура ПриЗаписи(Отказ)
	
	// Не выполнять дальнейшие действия при обмене данными
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	// Не выполнять дальнейшие действия при обмене данными
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	Если ЭтоНовый() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	СерийныеНомера.Ссылка
		|ИЗ
		|	Справочник.СерийныеНомера КАК СерийныеНомера
		|ГДЕ
		|	СерийныеНомера.Наименование = &Наименование
		|	И СерийныеНомера.Владелец = &Владелец";
		
		Запрос.УстановитьПараметр("Владелец", Владелец);
		Запрос.УстановитьПараметр("Наименование", СокрЛП(Наименование));
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			Отказ = Истина;
			
			ТекстСообщения = НСтр("ru = 'У номенклатуры %1% уже введен серийный номер %2%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1%", Владелец);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%2%", СокрЛП(Наименование));
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИнтеграцияГИСМВызовСервера.ЭтоНомерКиЗ(Наименование) Тогда
		НомерКиЗГИСМ =Наименование;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли