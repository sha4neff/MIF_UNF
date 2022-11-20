
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИсходныеЗначения = Новый Структура("НалогообложениеНДС, Патент, УчитыватьВНУ");
	ЗаполнитьЗначенияСвойств(ИсходныеЗначения, Параметры);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НалогообложениеНДС, Патент, УчитыватьВНУ, ИдентификаторСтроки");
	
	Элементы.УчитыватьВНУ.Видимость = Параметры.ВидимостьУчитыватьВНУ;
	Элементы.НалогообложениеНДС.Видимость = Параметры.ВидимостьНалогообложениеНДС;
	Элементы.Патент.Видимость = Параметры.ВидимостьПатент;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УчитыватьВНУПриИзменении(Элемент)
	
	Если УчитыватьВНУ Тогда
		НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.НеОблагаетсяНДС");
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик события нажатия кнопки ОК.
//
&НаКлиенте
Процедура КнопкаОК(Команда)
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеРеквизитовФормы(Отказ);
	
	Если НЕ Отказ Тогда
		БылиВнесеныИзменения = ПроверитьМодифицированностьФормы();
		СтруктураВозврата = Новый Структура();
		СтруктураВозврата.Вставить("НалогообложениеНДС", НалогообложениеНДС);
		СтруктураВозврата.Вставить("Патент", Патент);
		СтруктураВозврата.Вставить("УчитыватьВНУ", УчитыватьВНУ);
		СтруктураВозврата.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
		СтруктураВозврата.Вставить("БылиВнесеныИзменения", БылиВнесеныИзменения);
		СтруктураВозврата.Вставить("КодВозвратаДиалога", КодВозвратаДиалога.ОК);
		Закрыть(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события нажатия кнопки Отмена.
//
&НаКлиенте
Процедура КнопкаОтмена(Команда)
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("БылиВнесеныИзменения", Ложь);
	СтруктураВозврата.Вставить("КодВозвратаДиалога", КодВозвратаДиалога.Отмена);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Процедура проверяет правильность заполнения реквизитов формы.
//
Процедура ПроверитьЗаполнениеРеквизитовФормы(Отказ)
	
	Если НЕ ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не заполнено налогообложение!'");
		Сообщение.Поле = "НалогообложениеНДС";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеРеквизитовФормы()

&НаКлиенте
// Процедура проверяет модифицированность формы.
//
Функция ПроверитьМодифицированностьФормы()
	
	БылиВнесеныИзменения = Ложь;
	
	Для каждого КлючЗначение Из ИсходныеЗначения Цикл
		
		Если КлючЗначение.Значение <> ЭтаФорма[КлючЗначение.Ключ] Тогда
			БылиВнесеныИзменения = Истина;
			Прервать;
		КонецЕсли; 
		
	КонецЦикла; 
	
	Возврат БылиВнесеныИзменения;
	
КонецФункции // ПроверитьМодифицированностьФормы()

#КонецОбласти




