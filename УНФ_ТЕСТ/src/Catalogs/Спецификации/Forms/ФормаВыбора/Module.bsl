
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ПроизводствоСервер.ДобавитьОтборыСпецификации(Параметры, Отказ);
	
	УстановитьОтборНедействительная(ЭтотОбъект);
	
	// МобильныйКлиент
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ЭтоМобильныйКлиент = Истина;
	КонецЕсли;
	// Конец МобильныйКлиент
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СпецификацияЗаписана" Тогда
		
		СтрокаСписка = Элементы.Список.ТекущиеДанные;
		Если СтрокаСписка <> Неопределено И Параметр.Ссылка = СтрокаСписка.Ссылка Тогда
			ОтразитьВозможностьУстановкиСпецификацииКакОсновной(Параметр.Недействителен, Параметр.Заказ);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если НЕ ЭтоМобильныйКлиент Тогда
		
		// СтандартныеПодсистемы.ПодключаемыеКоманды
		ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
		// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	КонецЕсли;
	
	ОтразитьВозможностьУстановкиСпецификацииКакОсновной();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьКакОсновную(Команда)
	
	СтрокаСписка = Элементы.Список.ТекущиеДанные;
	Если СтрокаСписка=Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИспользоватьКакОсновнуюСервер(СтрокаСписка.Владелец, СтрокаСписка.ХарактеристикаПродукции, СтрокаСписка.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ИспользоватьКакОсновнуюСервер(Номенклатура, Характеристика, Спецификация)
	
	Справочники.Спецификации.ИзменитьПризнакОсновнаяСпецификация(Номенклатура, Характеристика, Спецификация); 
	
	Элементы.Список.Обновить();
	Элементы.Список.ТекущаяСтрока = Спецификация;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительную(Команда)
	
	Элементы.ФормаПоказыватьНедействительную.Пометка = Не Элементы.ФормаПоказыватьНедействительную.Пометка;
	
	УстановитьОтборНедействительная(ЭтотОбъект)
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	НовоеУсловноеОформление = Список.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Недействителен", Истина, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти); 

КонецПроцедуры

&НаКлиенте
Процедура ОтразитьВозможностьУстановкиСпецификацииКакОсновной(Недействителен = Неопределено, Заказ = Неопределено)
	
	Если Недействителен = Неопределено Тогда
		СтрокаСписка = Элементы.Список.ТекущиеДанные;
		Если СтрокаСписка = Неопределено 
			ИЛИ НЕ СтрокаСписка.Свойство("Недействителен") 
			ИЛИ НЕ СтрокаСписка.Свойство("Заказ") Тогда
			Недействителен = Ложь;
			Заказ = Неопределено;
		Иначе
			Недействителен = СтрокаСписка.Недействителен;
			Заказ = СтрокаСписка.Заказ;
		КонецЕсли; 
	КонецЕсли;
	ДоступностьКнопки = НЕ Недействителен И НЕ ЗначениеЗаполнено(Заказ);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаИспользоватьКакОсновную", "Доступность", ДоступностьКнопки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборНедействительная(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Форма.Элементы.ФормаПоказыватьНедействительную.Пометка);
	
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти 

