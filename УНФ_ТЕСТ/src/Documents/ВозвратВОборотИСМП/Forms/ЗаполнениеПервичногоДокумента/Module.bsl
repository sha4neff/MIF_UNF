#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, 
		"Оплачен, ВидПервичногоДокумента, НаименованиеПервичногоДокумента, НомерПервичногоДокумента, ДатаПервичногоДокумента, Организация, ПервичныйДокумент");
	
	НастроитьЗависимыеЭлементыФормы();
	
	Элементы.ВидПервичногоДокумента.СписокВыбора.ЗагрузитьЗначения(Параметры.ДоступныеВидыПервичныхДокументов.ВыгрузитьЗначения());
	
	СброситьРазмерыИПоложениеОкна();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитов(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Оплачен",                          Оплачен);
	Результат.Вставить("ВидПервичногоДокумента",           ВидПервичногоДокумента);
	Результат.Вставить("НаименованиеПервичногоДокумента",  НаименованиеПервичногоДокумента);
	Результат.Вставить("НомерПервичногоДокумента",         НомерПервичногоДокумента);
	Результат.Вставить("ДатаПервичногоДокумента",          ДатаПервичногоДокумента);
	Результат.Вставить("ПредставлениеПервичногоДокумента", ИнтеграцияИСМПКлиентСервер.ПредставлениеПервичногоДокумента(Результат));
	Результат.Вставить("ПервичныйДокумент",                ПервичныйДокумент);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидПервичногоДокументаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы("ВидПервичногоДокумента");
	
	Если ВидПервичногоДокумента <> ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.Прочее") Тогда
		НаименованиеПервичногоДокумента = "";
	КонецЕсли;
	
	ПервичныйДокумент = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПервичныйДокументПриИзменении(Элемент)
	
	ДанныеПервичногоДокумента = ДанныеПервичногоДокумента(ПервичныйДокумент);
	
	Если ДанныеПервичногоДокумента <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеПервичногоДокумента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДанныеПервичногоДокумента(ПервичныйДокумент)
	
	Если Не ЗначениеЗаполнено(ПервичныйДокумент) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("НомерПервичногоДокумента", ПервичныйДокумент.Номер);
	ВозвращаемоеЗначение.Вставить("ДатаПервичногоДокумента",  ПервичныйДокумент.Дата);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("Документ.ВозвратВОборотИСМП.Форма.ЗаполнениеПервичногоДокумента", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеРеквизитов(Отказ)
	
	ОчиститьСообщения();
	
	ШаблонСообщения = Нстр("ru='Поле ""%1"" не заполнено'");
	
	Если Не ЗначениеЗаполнено(ВидПервичногоДокумента) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Вид первичного документа");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ВидПервичногоДокумента",,Отказ);
	КонецЕсли;
	
	Если ВидПервичногоДокумента = ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.Прочее")
		И Не ЗначениеЗаполнено(НаименованиеПервичногоДокумента) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Наименование первичного документа");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НаименованиеПервичногоДокумента",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерПервичногоДокумента) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Номер первичного документа");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НомерПервичногоДокумента",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПервичногоДокумента) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Дата первичного документа");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ДатаПервичногоДокумента",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормы(СписокРеквизитов = "")
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	ЭтоТоварныйЧек = ВидПервичногоДокумента = ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.ТоварныйЧек");
	ЭтоКассовыйЧек = ВидПервичногоДокумента = ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.КассовыйЧек");
	ЭтоПрочее      = ВидПервичногоДокумента = ПредопределенноеЗначение("Перечисление.ВидыПервичныхДокументовИСМП.Прочее");
	
	Если Инициализация Или СтруктураРеквизитов.Свойство("ВидПервичногоДокумента") Тогда
		СобытияФормИСМПКлиентСервер.УправлениеДоступностьюЭлементовФормы(ЭтотОбъект);
		Элементы.НаименованиеПервичногоДокумента.Видимость = ЭтоПрочее;
	КонецЕсли;
	
	СвязьПоОрганизации = Новый СвязьПараметраВыбора("Отбор.Организация", "Организация");
	СвязиПервичногоДокумента = Новый Массив();
	СвязиПервичногоДокумента.Добавить(СвязьПоОрганизации);
	Элементы.ПервичныйДокумент.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПервичногоДокумента);
	
	ДоступныеТипыПеривчногоДокумента = Новый Массив();
	Для Каждого ДоступныйТип Из Метаданные.ОпределяемыеТипы.ВозвратВОборотПервичныйДокументИСМП.Тип.Типы() Цикл
		
		ЭтоОптовыйДокумент = Метаданные.ОпределяемыеТипы.ОснованиеОтгрузкаТоваровИСМП.Тип.СодержитТип(ДоступныйТип);
		Если ЭтоТоварныйЧек И ЭтоОптовыйДокумент 
			Или ЭтоКассовыйЧек И Не ЭтоОптовыйДокумент Тогда
			ДоступныеТипыПеривчногоДокумента.Добавить(ДоступныйТип);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДоступныеТипыПеривчногоДокумента.Количество() > 0 Тогда
		Элементы.ПервичныйДокумент.Видимость       = (ЭтоТоварныйЧек Или ЭтоКассовыйЧек);
		Элементы.ПервичныйДокумент.ОграничениеТипа = Новый ОписаниеТипов(ДоступныеТипыПеривчногоДокумента);
	Иначе
		Элементы.ПервичныйДокумент.Видимость       = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти