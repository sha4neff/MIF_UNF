
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.СправочникОбъект <> Неопределено Тогда
		СправочникОбъект = Параметры.СправочникОбъект;
	Иначе
		
	КонецЕсли;
	
	НеФормироватьПодтвержденияАвтоматически = СправочникОбъект.НеФормироватьПодтвержденияАвтоматически;
	ИспользоватьСервисОнлайнПроверки = СправочникОбъект.ИспользоватьСервисОнлайнПроверкиОтчетов;
	ДоступнаЭлектроннаяПодписьВМоделиСервиса = ЭлектроннаяПодписьВМоделиСервиса.ИспользованиеВозможно();
	
	ИдентификаторСистемыОтправителяПФР = СправочникОбъект.ИдентификаторСистемыОтправителяПФР;
	ИспользоватьОсобыйИдентификаторСистемыОтправителя = ЗначениеЗаполнено(ИдентификаторСистемыОтправителяПФР);
	ИдентификаторСистемыОтправителяФСГС = СправочникОбъект.ИдентификаторСистемыОтправителяФСГС;
	ИспользоватьОсобыйИдентификаторСистемыОтправителяФСГС = ЗначениеЗаполнено(ИдентификаторСистемыОтправителяФСГС);
	ЯвляетсяУчетнойЗаписьюУполномоченногоПредставителя = СправочникОбъект.ЯвляетсяУчетнойЗаписьюУполномоченногоПредставителя;
	ПолноеНаименованиеУполномоченногоПредставителя = СправочникОбъект.ПолноеНаименованиеУполномоченногоПредставителя;
	ИННУполномоченногоПредставителя = СправочникОбъект.ИННУполномоченногоПредставителя;
	КППУполномоченногоПредставителя = СправочникОбъект.КППУполномоченногоПредставителя;
	
	ОператорРегНомерПФР = СправочникОбъект.ОператорРегНомерПФР;
	ОператорНаименованиеПолное = СправочникОбъект.ОператорНаименованиеПолное;
	ОператорНаименованиеКраткое = СправочникОбъект.ОператорНаименованиеКраткое;
	ОператорИНН = СправочникОбъект.ОператорИНН;
	ОператорКПП = СправочникОбъект.ОператорКПП;
	
	ОтключитьАвтообмен = СправочникОбъект.ОтключитьАвтообмен;
	АвтообменПроизводится = Истина;
	Элементы.ОтключитьАвтообмен.Доступность = АвтообменПроизводится;
	
	Элементы.ГруппаДополнительныеВозможности.Доступность = НЕ СправочникОбъект.ОбменНапрямую;
	Элементы.ГруппаИдентификаторОтправителяПФР.Доступность = СправочникОбъект.ПредназначенаДляДокументооборотаСПФР;
	Элементы.ГруппаИдентификаторОтправителяФСГС.Доступность = СправочникОбъект.ПредназначенаДляДокументооборотаСФСГС;
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ПоддержкаСервисаОнлайнПроверкиВУниверсальномФорматеДляСпецоператора =
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьПараметрСпецоператора(
		СправочникОбъект.СпецоператорСвязи,
		"ОнлайнПроверкаПризнак");
	ПоддержкаСервисаОнлайнПроверкиВУниверсальномФормате = НЕ СправочникОбъект.ОбменНапрямую
		И (СправочникОбъект.СпецоператорСвязи = Перечисления.СпецоператорыСвязи.Такском
		ИЛИ (ЗначениеЗаполнено(ПоддержкаСервисаОнлайнПроверкиВУниверсальномФорматеДляСпецоператора)
		И Булево(ПоддержкаСервисаОнлайнПроверкиВУниверсальномФорматеДляСпецоператора) = Истина));
	Элементы.ИспользоватьСервисОнлайнПроверки.Доступность = ПоддержкаСервисаОнлайнПроверкиВУниверсальномФормате;
	
	Сертификат 	= Новый Структура("Отпечаток", СправочникОбъект.СертификатРуководителя);
	
	Если СправочникОбъект.ЭлектроннаяПодписьВМоделиСервиса
		И ДоступнаЭлектроннаяПодписьВМоделиСервиса Тогда
		Элементы.ГруппаСпособПодтверждения.Видимость = Истина;
		Сертификат = ЭлектроннаяПодписьВМоделиСервисаБРОВызовСервера.СвойстваРасшифрованияПодписанияСертификата(Сертификат);
		Элементы.СпособПодтвержденияКриптоопераций.Заголовок = 
				СформироватьЗаголовокПодтвержденияСМС(Сертификат.СпособПодтвержденияКриптоопераций);
		Элементы.СпособПодтвержденияКриптоопераций.Подсказка = 
				ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьОписаниеСпособовПодтвержденияКриптоопераций();
	Иначе	
		Элементы.ГруппаСпособПодтверждения.Видимость 	= Ложь;
	КонецЕсли;	
	
	УправлениеЭУ();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомандаПоУмолчаниюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	НеФормироватьПодтвержденияАвтоматически = Ложь;
	ИспользоватьСервисОнлайнПроверки = ПоддержкаСервисаОнлайнПроверкиВУниверсальномФормате;
	ИспользоватьОсобыйИдентификаторСистемыОтправителя = Ложь;
	ЯвляетсяУчетнойЗаписьюУполномоченногоПредставителя = Ложь;
	ОтключитьАвтообмен = Ложь;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОсобыйИдентификаторСистемыОтправителяПриИзменении(Элемент)
	
	УправлениеЭУ();
	
	Если ИспользоватьОсобыйИдентификаторСистемыОтправителя И НЕ ЗначениеЗаполнено(ИдентификаторСистемыОтправителяПФР) Тогда
		ТекущийЭлемент = Элементы.ИдентификаторСистемыОтправителяПФР;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЯвляетсяУчетнойЗаписьюУполномоченногоПредставителяПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьАвтообменПриИзменении(Элемент)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОсобыйИдентификаторСистемыОтправителяФСГСПриИзменении(Элемент)
	
	УправлениеЭУ();
	
	Если ИспользоватьОсобыйИдентификаторСистемыОтправителяФСГС И НЕ ЗначениеЗаполнено(ИдентификаторСистемыОтправителяФСГС) Тогда
		ТекущийЭлемент = Элементы.ИдентификаторСистемыОтправителяФСГС;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторСистемыОтправителяФСГСОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Если ВСловеПрисутствуютРусскиеБуквыИлиНеразрешенныеСимволы(СокрЛП(Текст)) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПоказатьПредупреждение(, "В поле присутствуют недопустимые символы или символы кириллицы, введите корректный идентификатор.");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособПодтвержденияКриптооперацийОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка 	= Ложь;
	ПараметрыФормы			= Новый Структура("ЦиклКриптооперации", Ложь);
	ОбработкаИзменения		= Новый ОписаниеОповещения("ПослеИзмененияПодтвержденияСМС", ЭтотОбъект);
	ЭлектроннаяПодписьВМоделиСервисаКлиент.ИзменитьСпособПодтвержденияКриптоопераций(Сертификат, ОбработкаИзменения, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияПодтвержденияСМС(РезультатВыбора, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		Элементы.СпособПодтвержденияКриптоопераций.Заголовок = СформироватьЗаголовокПодтвержденияСМС(РезультатВыбора.СпособПодтвержденияКриптоопераций);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаПоУмолчаниюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, "Восстановить исходные настройки?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("НеФормироватьПодтвержденияАвтоматически", НеФормироватьПодтвержденияАвтоматически);
	Результат.Вставить("ИспользоватьСервисОнлайнПроверкиОтчетов", ИспользоватьСервисОнлайнПроверки);
	Результат.Вставить("ЯвляетсяУчетнойЗаписьюУполномоченногоПредставителя",
		ЯвляетсяУчетнойЗаписьюУполномоченногоПредставителя);
	Результат.Вставить("ПолноеНаименованиеУполномоченногоПредставителя", ПолноеНаименованиеУполномоченногоПредставителя);
	Результат.Вставить("ИННУполномоченногоПредставителя", ИННУполномоченногоПредставителя);
	Результат.Вставить("КППУполномоченногоПредставителя", КППУполномоченногоПредставителя);
	Результат.Вставить("ИдентификаторСистемыОтправителяПФР",
		?(ИспользоватьОсобыйИдентификаторСистемыОтправителя, ИдентификаторСистемыОтправителяПФР, ""));
	Результат.Вставить("ОтключитьАвтообмен", ОтключитьАвтообмен);
	Результат.Вставить("ИдентификаторСистемыОтправителяФСГС",
		?(ИспользоватьОсобыйИдентификаторСистемыОтправителяФСГС, ИдентификаторСистемыОтправителяФСГС, ""));
	Результат.Вставить("ОператорРегНомерПФР", ОператорРегНомерПФР);
	Результат.Вставить("ОператорНаименованиеПолное", ОператорНаименованиеПолное);
	Результат.Вставить("ОператорНаименованиеКраткое", ОператорНаименованиеКраткое);
	Результат.Вставить("ОператорИНН", ОператорИНН);
	Результат.Вставить("ОператорКПП", ОператорКПП);
	
	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭУ()
	
	Элементы.ИдентификаторСистемыОтправителяПФР.Доступность = ИспользоватьОсобыйИдентификаторСистемыОтправителя;
	Элементы.ИдентификаторСистемыОтправителяФСГС.Доступность = ИспользоватьОсобыйИдентификаторСистемыОтправителяФСГС;
	Элементы.ГруппаПанельУП.Доступность = ЯвляетсяУчетнойЗаписьюУполномоченногоПредставителя;
	
КонецПроцедуры

&НаКлиенте
Функция ВСловеПрисутствуютРусскиеБуквыИлиНеразрешенныеСимволы(Знач СтрокаПараметр) 
	
	СтрокаПараметр = СокрЛП(СтрокаПараметр);
	
	СписокДопустимыхЗначений = Новый Массив;
	СписокДопустимыхЗначений.Добавить(184);
	СписокДопустимыхЗначений.Добавить(168);
	СписокДопустимыхЗначений.Добавить(44);
	СписокДопустимыхЗначений.Добавить(45);
	СписокДопустимыхЗначений.Добавить(46);
	СписокДопустимыхЗначений.Добавить(32);
	СписокДопустимыхЗначений.Добавить(48);
	СписокДопустимыхЗначений.Добавить(49);
	СписокДопустимыхЗначений.Добавить(50);
	СписокДопустимыхЗначений.Добавить(51);
	СписокДопустимыхЗначений.Добавить(52);
	СписокДопустимыхЗначений.Добавить(53);
	СписокДопустимыхЗначений.Добавить(54);
	СписокДопустимыхЗначений.Добавить(55);
	СписокДопустимыхЗначений.Добавить(56);
	СписокДопустимыхЗначений.Добавить(57);
	
	Для ИндексСимвола = 1 По СтрДлина(СтрокаПараметр) Цикл
		Код = КодСимвола(СтрокаПараметр, ИндексСимвола);
		Если (Код >= 1040 И Код <= 1103) ИЛИ Код = 1105 ИЛИ Код = 1025  Тогда
			// русские буквы
			Возврат Истина;
		ИначеЕсли (СписокДопустимыхЗначений.Найти(Код) <> Неопределено) Тогда
			// неразрешенные символы
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьЗаголовокПодтвержденияСМС(ТекущийРежим)
	
	КодЯзыка 		= "ru";
	ТекстЗаголовка	= ?(ТекущийРежим <> Перечисления.СпособыПодтвержденияКриптоопераций.ДолговременныйТокен, 
						НСтр("ru = 'Подтверждать'", КодЯзыка), 
						НСтр("ru = 'Не подтверждать'", КодЯзыка));
						
	Отступ			= Новый ФорматированнаяСтрока(" ");
	СтрокаСсылка	= Новый ФорматированнаяСтрока(ТекстЗаголовка, , , , "СМС");
	Результат		= Новый ФорматированнаяСтрока(Отступ, СтрокаСсылка);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти