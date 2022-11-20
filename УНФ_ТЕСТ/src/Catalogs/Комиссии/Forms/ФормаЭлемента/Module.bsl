
#Область Служебные

&НаСервере
Процедура УправлениеДоступностью()
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ГруппаДатаНомерПриказа");
	МассивЭлементов.Добавить("ГруппаЗаголовок");
	МассивЭлементов.Добавить("ГруппаАналитика");
	МассивЭлементов.Добавить("ПодписиКомиссии");
	МассивЭлементов.Добавить("ПериодДействияКомиссии");
	МассивЭлементов.Добавить("ГруппаУтвердил");
	
	КомиссияИспользуетсяВДокументах = Справочники.Комиссии.КомиссияИспользуетсяВДокументах(Объект.Ссылка);
	Для каждого ЭлементаМассива Из МассивЭлементов Цикл
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ЭлементаМассива, "ТолькоПросмотр", КомиссияИспользуетсяВДокументах);
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияПредупреждение", "Видимость", КомиссияИспользуетсяВДокументах);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораВидовДокументовНаСервере()
	
	СоответствиеДокументов = Справочники.Комиссии.ДокументыСКомиссиями();
	Для каждого ЗначениеСоответствия Из СоответствиеДокументов Цикл
		
		Элементы.ВидДокумента.СписокВыбора.Добавить(ЗначениеСоответствия.Ключ, ЗначениеСоответствия.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДублиФизическихЛиц(Отказ)
	
	ТаблицаФизическихЛиц = Объект.ПодписиКомиссии.Выгрузить(, "ПодписьЧленаКомиссии");
	
	ТаблицаФизическихЛиц.Колонки.Добавить("Счетчик", Новый ОписаниеТипов("Число"));
	ТаблицаФизическихЛиц.ЗаполнитьЗначения(1, "Счетчик");
	ТаблицаФизическихЛиц.Свернуть("ПодписьЧленаКомиссии", "Счетчик");
	
	ШаблонСообщения = НСтр("ru ='Физическое лицо %1 добавлено более одного раза в комиссию. Необходимо пересмотреть состав комиссии.'");
	Для каждого СтрокаТаблицы Из ТаблицаФизическихЛиц Цикл
		
		Если СтрокаТаблицы.Счетчик > 1 Тогда
			
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ШаблонСообщения, СтрокаТаблицы.ПодписьЧленаКомиссии), , , , Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаПодписаниеПриказа) Тогда
		
		Объект.ДатаПодписаниеПриказа = ТекущаяДатаСеанса();
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораВидовДокументовНаСервере();
	УправлениеДоступностью();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьДублиФизическихЛиц(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область Реквизиты

&НаКлиенте
Процедура ПодписиКомиссииЭтоПодписьПредседателяКомиссииПриИзменении(Элемент)
	
	ДанныеТекущейСтроки = Элементы.ПодписиКомиссии.ТекущиеДанные;
	Для каждого СтрокаТаблицы Из Объект.ПодписиКомиссии Цикл
		
		Если СтрокаТаблицы.ЭтоПодписьПредседателяКомиссии
			И ДанныеТекущейСтроки <> СтрокаТаблицы Тогда
			
			СтрокаТаблицы.ЭтоПодписьПредседателяКомиссии = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписиКомиссииПриИзменении(Элемент)
	
	Если Объект.ПодписиКомиссии.Количество() = 1 Тогда
		
		Объект.ПодписиКомиссии[0].ЭтоПодписьПредседателяКомиссии = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Библиотеки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
