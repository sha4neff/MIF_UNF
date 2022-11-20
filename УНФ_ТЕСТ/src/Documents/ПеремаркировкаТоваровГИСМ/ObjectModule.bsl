#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	МаркировкаТоваровГИСМПереопределяемый.ОбработкаЗаполненияПеремаркировкаТоваров(ДанныеЗаполнения, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ИнтеграцияИС.ИспользоватьПодразделения() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	КонецЕсли;
	
	МаркировкаТоваровГИСМПереопределяемый.ОбработкаПроверкиЗаполненияПеремаркировкаТоваров(Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, ЭтотОбъект);
	
	МаркировкаТоваровГИСМ.ПроверитьСоответствияGTIN(ЭтотОбъект, Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МаркировкаТоваровГИСМПереопределяемый.ПередЗаписьюПеремаркировкаТоваров(Отказ, РежимЗаписи, РежимПроведения, ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	МаркировкаТоваровГИСМПереопределяемый.ПриКопированииПеремаркировкаТоваров(ОбъектКопирования, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МаркировкаТоваровГИСМПереопределяемый.ОбработкаПроведенияПеремаркировкаТоваров(Отказ, РежимПроведения, ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	МаркировкаТоваровГИСМПереопределяемый.ОбработкаУдаленияПроведенияПереМаркировкаТоваров(Отказ, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли