
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"ИдентификаторВладельца, ИмяМакетаСКД, ИзмерениеПланирования, Периодичность,
		|НачалоПланирования, КоличествоПериодов, ТекущийДокумент, ДетализироватьДоЗаказа");
	
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	СдвигПериода = -1;
	ИзменитьПериод(ЭтотОбъект);
	ЗагрузитьНастройкиОтбораПоУмолчанию(Параметры.НачальныйОтбор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПредыдущийПериод(Команда)
	
	СдвигПериода = СдвигПериода - 1;
	ИзменитьПериод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийПериод(Команда)
	
	СдвигПериода = СдвигПериода + 1;
	ИзменитьПериод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрошлыйПериод(Команда)
	
	СдвигПериода = -1;
	ИзменитьПериод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьДокумент(Команда)
	
	НачатьВыполнениеДлительнойОперации(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВДокумент(Команда)
	
	НачатьВыполнениеДлительнойОперации(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеПериода(Форма)
	
	Форма.ПредставлениеПериода = СтрШаблон(
		"%1 - %2",
		Формат(Форма.ДатаНачала, "ДЛФ=DD"),
		Формат(Форма.ДатаОкончания, "ДЛФ=DD")
	);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма)
	
	Форма.ДатаНачала = НачалоДня(УправлениеНебольшойФирмойКлиентСервер.РассчитатьДатуОкончанияПериода(
		Форма.НачалоПланирования, Форма.Периодичность, Форма.КоличествоПериодов * Форма.СдвигПериода) + 86400);
	Форма.ДатаОкончания = УправлениеНебольшойФирмойКлиентСервер.РассчитатьДатуОкончанияПериода(
		Форма.ДатаНачала, Форма.Периодичность, Форма.КоличествоПериодов);
	
	УстановитьПредставлениеПериода(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию(НачальныйОтбор = Неопределено)
	
	СхемаКомпоновкиДанных = Документы.ПланПродаж.ПолучитьМакет(ИмяМакетаСКД);
	
	Поле = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("ОбъектПланирования");
	Если Поле <> Неопределено Тогда
		
		Поле.Заголовок = Строка(ИзмерениеПланирования);
		Поле.ТипЗначения = ПланированиеКлиентСервер.ОписаниеТипаПланированияПоИзмерению(ИзмерениеПланирования);
		
		Если ИзмерениеПланирования = Перечисления.ИзмеренияПланирования.ГруппаНоменклатуры Тогда
			Поле.ПараметрыРедактирования.УстановитьЗначениеПараметра("ВыборГруппИЭлементов", ГруппыИЭлементы.Группы);
			Поле.ПараметрыРедактирования.УстановитьЗначениеПараметра("ФормаВыбора", "Справочник.Номенклатура.Форма.ФормаВыбораГруппы");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИзмерениеПланирования = Перечисления.ИзмеренияПланирования.Номенклатура Тогда
		
		ЭлементОтбора = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Характеристика");
		ЭлементОтбора.Использование = Ложь;
		
		ЭлементОтбора = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбъектПланирования.КатегорияНоменклатуры");
		ЭлементОтбора.Использование = Ложь;
		
	КонецЕсли;
	
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтотОбъект.УникальныйИдентификатор)));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	Если ТипЗнч(НачальныйОтбор) = Тип("Структура") Тогда
		Для Каждого КлючИЗначение Из НачальныйОтбор Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				КомпоновщикНастроек.Настройки.Отбор,
				КлючИЗначение.Ключ,
				КлючИЗначение.Значение
				,
				,
				,
				Ложь
			);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиСКД()
	
	КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ГоризонтальноеРасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
	КомпоновщикНастроек.Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("ВертикальноеРасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПериода",	ДатаНачала);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонецПериода",	КонецДня(ДатаОкончания));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Периодичность",	Периодичность);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СдвигПериода",	КоличествоПериодов * СдвигПериода);
	
	Если КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(Новый ПараметрКомпоновкиДанных("ТекущийДокумент")) <> Неопределено Тогда
		КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ТекущийДокумент", ТекущийДокумент);
	КонецЕсли;
	
	Если КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(Новый ПараметрКомпоновкиДанных("ИзмерениеПланирования")) <> Неопределено Тогда
		КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ИзмерениеПланирования", ИзмерениеПланирования);
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	ГруппировкаКД = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКД.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	ПолеГруппировки = ГруппировкаКД.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование = Истина;
	ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ДатаПланирования");
	
	ПолеГруппировки = ГруппировкаКД.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование = Истина;
	ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ОбъектПланирования");
	
	Если ИзмерениеПланирования = Перечисления.ИзмеренияПланирования.Номенклатура Тогда
		
		ПолеГруппировки = ГруппировкаКД.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Характеристика");
		
		ПолеГруппировки = ГруппировкаКД.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ЕдиницаИзмерения");
		
	КонецЕсли;
	
	Если ДетализироватьДоЗаказа Тогда
		ПолеГруппировки = ГруппировкаКД.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ЗаказПокупателя");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДлительныеОперации

&НаКлиенте
Процедура НачатьВыполнениеДлительнойОперации(ОчищатьПередЗаполнением)
	
	ЭтотОбъект.ТолькоПросмотр = Истина;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание;
	
	ДлительнаяОперация = НачатьВыполнениеДлительнойОперацииНаСервере();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания				= Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения		= Ложь;
	ПараметрыОжидания.ВыводитьСообщения					= Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать	= Ложь;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ДлительнаяОперацияЗавершение",
		ЭтотОбъект,
		Новый Структура("ОчищатьПередЗаполнением", ОчищатьПередЗаполнением)
	);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьВыполнениеДлительнойОперацииНаСервере()
	
	УстановитьНастройкиСКД();
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("НастройкиКомпоновкиДанных",	КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыПроцедуры.Вставить("ИмяМакетаСКД",					ИмяМакетаСКД);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.ИдентификаторВладельца);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания	= НСтр("ru='Получение данных для заполнения плана продаж'");
	ПараметрыВыполнения.ОжидатьЗавершение			= 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Документы.ПланПродаж.ПолучитьДанныеЗаполнения",
		ПараметрыПроцедуры,
		ПараметрыВыполнения
	);
	
КонецФункции

&НаКлиенте
Процедура ДлительнаяОперацияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЭтотОбъект.ТолькоПросмотр = Ложь;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОтборы;
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(
			НСтр("ru='Не удалось получить данные для заполнения по причине: %1'"),
			Результат.ПодробноеПредставлениеОшибки
		));
		
		Возврат;
		
	КонецЕсли;
	
	РезультатЗаполнения = Новый Структура;
	РезультатЗаполнения.Вставить("ОчищатьПередЗаполнением", ДополнительныеПараметры.ОчищатьПередЗаполнением);
	РезультатЗаполнения.Вставить("АдресВХранилище",			Результат.АдресРезультата);
	
	Закрыть(РезультатЗаполнения);
	
КонецПроцедуры

#КонецОбласти
