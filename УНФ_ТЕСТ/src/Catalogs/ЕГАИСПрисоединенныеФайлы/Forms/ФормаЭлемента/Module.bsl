
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекстСообщенияXML = ИнтеграцияИС.ТекстСообщенияXMLИзПротокола(Объект.Ссылка);
	ТекстСообщенияXML = ИнтеграцияИС.ФорматироватьXMLСПараметрами(
		ТекстСообщенияXML,
		ИнтеграцияИС.ПараметрыФорматированияXML(Истина, "  "));

	ТекстовыйДокументТекстСообщенияXML.УстановитьТекст(ТекстСообщенияXML);
	
	РежимОтладки = ОбщегоНазначения.РежимОтладки();
	
	Элементы.ГруппаШапка.ТолькоПросмотр     = Не РежимОтладки;
	Элементы.ГруппаСообщение.ТолькоПросмотр = Не РежимОтладки;
	Элементы.ОперацияКвитанции.Видимость    = РежимОтладки;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти