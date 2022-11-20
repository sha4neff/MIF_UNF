#Область ОписаниеПеременных

&НаКлиенте
Перем СохранитьДанные;
&НаКлиенте
Перем ВыборОбработан;

#КонецОбласти

&НаКлиенте
Процедура КомандаОК(Команда)
	СтруктураВозвращаемыхДанных = Новый Структура("ДобавляемыеСтроки, Модифицированность", ПериодыСтажа, Модифицированность);
	
	СохранитьДанные = Истина;
	ВыборОбработан = Истина;
	ОповеститьОВыборе(СтруктураВозвращаемыхДанных);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	СохранитьДанные = Ложь;
    ВыборОбработан = Истина;
	ОповеститьОВыборе(Неопределено);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемПодтверждениеПолучено", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПодтверждениеПолучено(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОповеститьОВыборе(Неопределено);
	ВыборОбработан = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СохранитьДанные = Неопределено;
	ВыборОбработан = Ложь;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для Каждого ЗаписьСтажа Из Параметры.МассивЗаписейСтажа Цикл
		СтрокаСтажа = ПериодыСтажа.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаСтажа, ЗаписьСтажа);
	КонецЦикла;	
	ЗакрыватьПриВыборе = Ложь;
КонецПроцедуры
