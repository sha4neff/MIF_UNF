#Область ОписаниеПеременных

&НаКлиенте
Перем ОбработкаЗакрытия;

&НаСервере
Перем НеизвестныеШтрихкоды;

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	
	Для каждого СтрокаШтрихкода Из Параметры.НеизвестныеШтрихкоды Цикл
		НовыйШтрихкод = ШтрихкодыНоменклатуры.Добавить();
		НовыйШтрихкод.Штрихкод = СтрокаШтрихкода.Штрихкод;
		НовыйШтрихкод.Количество = СтрокаШтрихкода.Количество;
		
		// Если передаются входные параметры, заполняем их
		ЗаполнитьЗначенияСвойств(НовыйШтрихкод, СтрокаШтрихкода);
	КонецЦикла;
	
	НеизвестныеШтрихкоды = Параметры.НеизвестныеШтрихкоды;
	Если Параметры.Свойство("НоменклатураВладелец") Тогда
		// для серийных номеров - владелец известен
		НоменклатураВладелец = Параметры.НоменклатураВладелец;
	КонецЕсли;
	
	ВызовГосИС = Параметры.ВызовГосИС; // ГосИС: для ПроверкаИПодборПродукцииИСМП.СопоставлениеШтрихкодовЗавершение
	
КонецПроцедуры

&НаСервере
Процедура ЗарегистрироватьШтрихкодыНаСервере()
	
	Для каждого СтрокаШтрихкода Из ШтрихкодыНоменклатуры Цикл
		
		Если СтрокаШтрихкода.Зарегистрирован ИЛИ НЕ ЗначениеЗаполнено(СтрокаШтрихкода.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			
			МенеджерЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Номенклатура = СтрокаШтрихкода.Номенклатура;
			МенеджерЗаписи.Характеристика = СтрокаШтрихкода.Характеристика;
			МенеджерЗаписи.Партия = СтрокаШтрихкода.Партия;
			МенеджерЗаписи.Штрихкод = СтрокаШтрихкода.Штрихкод;
			МенеджерЗаписи.Записать();
			
			СтрокаШтрихкода.ЗарегистрированОбработкой = Истина;
			
		Исключение
		
		КонецПопытки
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		
		ЗарегистрироватьШтрихкодыНаСервере();
		
		НайденыНезарегистрированныеТовары = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован, ЗарегистрированОбработкой", Ложь, Ложь));
		Если НайденыНезарегистрированныеТовары.Количество() > 0 Тогда
			
			ТекстВопроса = НСтр(
				"ru='Не для всех новых штрихкодов указана соответствующая номенклатура.
				|Эти товары не будут перенесены в документ.
				|Отложите их в сторону как неотсканированные.'"
			);
			
			ПоказатьВопрос(Новый ОписаниеОповещения("ПеренестиВДокументЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
			Возврат;
			
		КонецЕсли;
		
		ПеренестиВДокументФрагмент();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РезультатВопроса = Результат;
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	
	ПеренестиВДокументФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументФрагмент()
	
	Перем ЗарегистрированныеШтрихкоды, НайденныеЗарегистрированныеШтрихкоды, НайденныеОтложенныеТовары, НайденныеПолученныеШтрихкоды, ОтложенныеТовары, ПараметрЗакрытия, ПолученыНовыеШтрихкоды, СтрокаШтрихкода;
	
	ЗарегистрированныеШтрихкоды = Новый Массив;
	НайденныеЗарегистрированныеШтрихкоды = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("ЗарегистрированОбработкой", Истина));
	Для каждого СтрокаШтрихкода Из НайденныеЗарегистрированныеШтрихкоды Цикл
		ЗарегистрированныеШтрихкоды.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
	КонецЦикла;
	
	ОтложенныеТовары = Новый Массив;
	НайденныеОтложенныеТовары = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован, ЗарегистрированОбработкой", Ложь, Ложь));
	Для каждого СтрокаШтрихкода Из НайденныеОтложенныеТовары Цикл
		ОтложенныеТовары.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
	КонецЦикла;
	
	ПолученыНовыеШтрихкоды = Новый Массив;
	НайденныеПолученныеШтрихкоды = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Зарегистрирован", Истина));
	Для каждого СтрокаШтрихкода Из НайденныеПолученныеШтрихкоды Цикл
		ПолученыНовыеШтрихкоды.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
	КонецЦикла;
	
	ПараметрЗакрытия = Новый Структура("ОтложенныеТовары, ЗарегистрированныеШтрихкоды, ПолученыНовыеШтрихкоды", ОтложенныеТовары, ЗарегистрированныеШтрихкоды, ПолученыНовыеШтрихкоды);
	ПараметрЗакрытия.Вставить("НайденыНезарегистрированныеТовары", Ложь); // ГосИС: для ПроверкаИПодборПродукцииИСМП.СопоставлениеШтрихкодовЗавершение
	Если ВызовГосИС Тогда // ГосИС: для ПроверкаИПодборПродукцииИСМП.СопоставлениеШтрихкодовЗавершение
		ПараметрЗакрытия = Неопределено;
	КонецЕсли;
	ОбработкаЗакрытия = Истина;
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда
	Сигнал();
	#КонецЕсли
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	ОбработкаЗакрытия = Ложь;
	ТекущийЭлемент = Элементы.Номенклатура;
	
	Попытка
		// Установка параметров выбора, если они есть.
		Элементы.Номенклатура.ПараметрыВыбора = ЭтаФорма.ВладелецФормы.Элементы.ЗапасыНоменклатура.ПараметрыВыбора;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеШтрихкода(Штрихкод)

	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.ДанныеШтрихкода(Штрихкод);
	
КонецФункции

// ПодключаемоеОборудование
&НаКлиенте
Функция ПолученыШтрихкоды(ДанныеШтрикодов)
	
	Модифицированность = Истина;
	
	Для каждого ЭлементДанных Из ДанныеШтрикодов Цикл
		НайденныеСтроки = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", ЭлементДанных.Штрихкод));
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].Количество = НайденныеСтроки[0].Количество + ЭлементДанных.Количество;
		Иначе
			ДанныеШтрихкода = ДанныеШтрихкода(ЭлементДанных.Штрихкод);
			Если ДанныеШтрихкода = Неопределено Тогда
				НовыйШтрихкод = ШтрихкодыНоменклатуры.Добавить();
				НовыйШтрихкод.Штрихкод = ЭлементДанных.Штрихкод;
				НовыйШтрихкод.Количество = ЭлементДанных.Количество;
				Если ЗначениеЗаполнено(НоменклатураВладелец) Тогда
					НовыйШтрихкод.Номенклатура = НоменклатураВладелец;
				КонецЕсли;
			Иначе
				НовыйШтрихкод = ШтрихкодыНоменклатуры.Добавить();
				НовыйШтрихкод.Штрихкод   = ЭлементДанных.Штрихкод;
				НовыйШтрихкод.Количество = ЭлементДанных.Количество;
				ЗаполнитьЗначенияСвойств(НовыйШтрихкод, ДанныеШтрихкода);
				НовыйШтрихкод.Зарегистрирован = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции // ПолученыШтрихкоды()
// Конец ПодключаемоеОборудование

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			Данные = МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
			ПолученыШтрихкоды(Данные);
		ИначеЕсли ИмяСобытия = "DataCollectionTerminal" Тогда
			ПолученыШтрихкоды(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ИспользоватьНеуникальныеШтрихКоды = Константы.ИспользоватьНеуникальныеШтрихКоды.Получить();
	
	Запрос = Новый Запрос;
	
	Если ИспользоватьНеуникальныеШтрихКоды Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаРегистрации.Номенклатура КАК Номенклатура,
		|	ТаблицаРегистрации.Характеристика КАК Характеристика,
		|	ТаблицаРегистрации.Партия КАК Партия,
		|	ВЫРАЗИТЬ(ТаблицаРегистрации.Штрихкод КАК СТРОКА(200)) КАК Штрихкод
		|ПОМЕСТИТЬ ВТаблицаРегистрации
		|ИЗ
		|	&ТаблицаРегистрации КАК ТаблицаРегистрации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
		|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
		|	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика,
		|	ШтрихкодыНоменклатуры.Партия КАК Партия,
		|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ШтрихкодыНоменклатуры.Партия) КАК ПартияПредставление
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТаблицаРегистрации КАК ВТаблицаРегистрации
		|		ПО ШтрихкодыНоменклатуры.Штрихкод = ВТаблицаРегистрации.Штрихкод
		|			И ШтрихкодыНоменклатуры.Номенклатура = ВТаблицаРегистрации.Номенклатура
		|			И ШтрихкодыНоменклатуры.Характеристика = ВТаблицаРегистрации.Характеристика
		|			И ШтрихкодыНоменклатуры.Партия = ВТаблицаРегистрации.Партия";
		
		
		ТаблицаРегистрации = ШтрихкодыНоменклатуры.Выгрузить(Новый Структура("Зарегистрирован", Ложь),"Штрихкод, Номенклатура, Характеристика, Партия");
		
		Запрос.УстановитьПараметр("ТаблицаРегистрации", ТаблицаРегистрации);
		
	Иначе
		
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
		|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
		|	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика,
		|	ШтрихкодыНоменклатуры.Партия КАК Партия,
		|	ШтрихкодыНоменклатуры.Номенклатура.Наименование КАК НоменклатураПредставление,
		|	ШтрихкодыНоменклатуры.Характеристика.Наименование КАК ХарактеристикаПредставление,
		|	ШтрихкодыНоменклатуры.Партия.Наименование КАК ПартияПредставление
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Штрихкод В(&Штрихкоды)";
		
	КонецЕсли;
	
	НоменклатураВДокументахСервер.ПреобразоватьТекстЗапросаРегистрШтрихкодыНоменклатуры(Запрос.Текст);
	
	Запрос.УстановитьПараметр("Штрихкоды", ШтрихкодыНоменклатуры.Выгрузить(Новый Структура("Зарегистрирован", Ложь),"Штрихкод").ВыгрузитьКолонку("Штрихкод"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда // Штрихкод уже записан в БД
		
		НайденныеСтроки = ШтрихкодыНоменклатуры.НайтиСтроки(Новый Структура("Штрихкод", Выборка.Штрихкод));
		
		Если НайденныеСтроки.Количество() Тогда
			
			СтрокаТЧ = НайденныеСтроки[0];
			
			ОписаниеОшибки = НСтр("ru='Такой штрихкод уже назначен для номенклатуры %Номенклатура%'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Номенклатура%", """" + Выборка.НоменклатураПредставление + """"
			+ ?(ЗначениеЗаполнено(Выборка.Характеристика), " " + НСтр("ru='с характеристикой'") + " """ + Выборка.ХарактеристикаПредставление + """", "")
			+ ?(ЗначениеЗаполнено(Выборка.Партия), " """ + НСтр("ru='в партии'") + " " + Выборка.ПартияПредставление + """", "")
			);
			
			ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки,,"ШтрихкодыНоменклатуры["+ШтрихкодыНоменклатуры.Индекс(СтрокаТЧ)+"].Штрихкод",,Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда, Отказ = Ложь)
	
	Если НЕ ОбработкаЗакрытия Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтменаЗавершение", ЭтотОбъект);
		
		ТекстВопроса = НСтр(
			"ru='Все товары не будут перенесены в документ.
			|Отложите их в сторону как неотсканированные.'"
		);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
		
	КонецЕсли;
	
	ОтложенныеТовары = Новый Массив;
	Для Каждого СтрокаШтрихкода Из ШтрихкодыНоменклатуры Цикл
		ОтложенныеТовары.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
	КонецЦикла;
	
	ПараметрЗакрытия = Новый Структура("ОтложенныеТовары, ЗарегистрированныеШтрихкоды, ПолученыНовыеШтрихкоды", ОтложенныеТовары, Новый Массив, Новый Массив);
	Если ВызовГосИС Тогда // ГосИС: для ПроверкаИПодборПродукцииИСМП.СопоставлениеШтрихкодовЗавершение
		ПараметрЗакрытия = Неопределено;
	КонецЕсли;
	ОбработкаЗакрытия = Истина;
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ОтложенныеТовары = Новый Массив;
	Для Каждого СтрокаШтрихкода Из ШтрихкодыНоменклатуры Цикл
		ОтложенныеТовары.Добавить(Новый Структура("Штрихкод, Количество", СтрокаШтрихкода.Штрихкод, СтрокаШтрихкода.Количество));
	КонецЦикла;
	
	ПараметрЗакрытия = Новый Структура("ОтложенныеТовары, ЗарегистрированныеШтрихкоды, ПолученыНовыеШтрихкоды", ОтложенныеТовары, Новый Массив, Новый Массив);
	Если ВызовГосИС Тогда // ГосИС: для ПроверкаИПодборПродукцииИСМП.СопоставлениеШтрихкодовЗавершение
		ПараметрЗакрытия = Неопределено;
	КонецЕсли;
	ОбработкаЗакрытия = Истина;
	Попытка
		Закрыть(ПараметрЗакрытия);
	Исключение
	КонецПопытки;
	
КонецПроцедуры // ОпределитьНеобходимостьЗаполненияДокументаПоОснованию()

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат
	КонецЕсли;
	
	Если НЕ ОбработкаЗакрытия Тогда
		Отмена(Неопределено, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		
		СтрокаТабличнойЧасти = Элементы.ШтрихкодыНоменклатуры.ТекущиеДанные;
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры
