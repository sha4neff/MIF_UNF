
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПредставлениеВарианта") И ЗначениеЗаполнено(Параметры.ПредставлениеВарианта) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменение настроек отчета ""%1""'"),
			Параметры.ПредставлениеВарианта);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикНастроекПользовательскиеНастройки

&НаКлиенте
Процедура КомпоновщикНастроекПользовательскиеНастройкиПриИзменении(Элемент)
	ПользовательскиеНастройкиМодифицированы = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	Если МодальныйРежим
		Или РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс
		Или ВладелецФормы = Неопределено Тогда
		Закрыть(Истина);
	Иначе
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("ВариантМодифицирован", Ложь);
		РезультатВыбора.Вставить("ПользовательскиеНастройкиМодифицированы", Ложь);
		
		Если ВариантМодифицирован Тогда
			РезультатВыбора.ВариантМодифицирован = Истина;
			РезультатВыбора.Вставить("НастройкиКД", Отчет.КомпоновщикНастроек.Настройки);
		КонецЕсли;
		
		Если ВариантМодифицирован Или ПользовательскиеНастройкиМодифицированы Тогда
			РезультатВыбора.ПользовательскиеНастройкиМодифицированы = Истина;
			РезультатВыбора.Вставить("ПользовательскиеНастройкиКД", Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
		КонецЕсли;
		
		ОповеститьОВыборе(РезультатВыбора);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
