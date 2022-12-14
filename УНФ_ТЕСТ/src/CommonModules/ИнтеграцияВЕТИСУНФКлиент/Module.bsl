#Область ИнтеграцияВЕТИСКлиентПереопределяемый

// Обработчик команды "Разбить строку".
//
//	Параметры:
//		ТЧ - ДанныеФормыКоллекция
//		ЭлементФормы - ТаблицаФормы
//		ОповещениеПослеРазбиения - ОписаниеОповещения
//		ПараметрыРазбиенияСтроки - см. ОбщегоНазначенияУТКлиент.ПараметрыРазбиенияСтроки.
//
Процедура РазбитьСтрокуТабличнойЧасти(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения = Неопределено, ПараметрыРазбиенияСтроки = Неопределено) Экспорт
	
	ТекущаяСтрока	= ЭлементФормы.ТекущиеДанные;
	ЧислоВведено = Истина;
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Для выполнения команды требуется выбрать строку табличной части.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли; 
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыРазбиенияСтроки.ИмяПоляКоличество] = 0
		И Не ПараметрыРазбиенияСтроки.РазрешитьНулевоеКоличество Тогда
		ТекстСообщения = НСтр("ru = 'Невозможно разбить строку с нулевым количеством.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	
	Если Отказ Тогда
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	
	Если ТекущаяСтрока[ПараметрыРазбиенияСтроки.ИмяПоляКоличество] <> 0 Тогда
		
		Количество = ?(ТекущаяСтрока[ПараметрыРазбиенияСтроки.ИмяПоляКоличество] = 0, 0, Неопределено);
		
		Если Количество = Неопределено Тогда
			РазбитьСтрокуТЧВводЧисла(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения, ПараметрыРазбиенияСтроки);
			Возврат;
			
		КонецЕсли;
	Иначе
		Количество = 0;
		
	КонецЕсли;
	
	РазбитьСтрокуТЧДобавлениеСтроки(ТЧ, ЭлементФормы, Количество, ОповещениеПослеРазбиения, ПараметрыРазбиенияСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормВЕТИСКлиентПереопределяемый

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма                   - УправляемаяФорма   - форма, в которой вызывается команда открытия обработки сопоставления;
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора,
//  ПараметрыПодбора        - Структура          - параметры открытия формы подбора товаров, состав полей определен в функции
//													ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ПараметрыФормыПодбораТоваров.
//
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено, ПараметрыПодбора = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Объект = Форма.Объект;
	ТипОбъекта = ТипЗнч(Объект.Ссылка);
	ЭтоПриходныйДокумент = Истина;
	ИмяТабличнойЧасти = Форма.ТекущийЭлемент.Имя;
	
	Если ТипОбъекта = Тип("ДокументСсылка.ИнвентаризацияПродукцииВЕТИС") ИЛИ ТипОбъекта = Тип("ДокументСсылка.ПроизводственнаяОперацияВЕТИС") Тогда
		ИмяРеквизитаОрганизация = "ХозяйствующийСубъект";
		ИмяРеквизитаПодразделение = "ТорговыйОбъект";
		ЭтоПриходныйДокумент = Ложь;
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ИсходящаяТранспортнаяОперацияВЕТИС") Тогда
		ИмяРеквизитаОрганизация = "ГрузоотправительХозяйствующийСубъект";
		ИмяРеквизитаПодразделение = "ТорговыйОбъект";
		ЭтоПриходныйДокумент = Ложь;
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
		 ИмяРеквизитаОрганизация = "ГрузополучательХозяйствующийСубъект";
		 ИмяРеквизитаПодразделение = "ТорговыйОбъект"
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект[ИмяРеквизитаОрганизация]) Тогда
		ДанныеХозяйствующегоСубъекта = ИнтеграцияВЕТИСУНФВызовСервера.ПолучитьДанныеХозяйствующгоСубъектаВЕТИС(Объект[ИмяРеквизитаОрганизация]);
	Иначе
		ДанныеХозяйствующегоСубъекта = Неопределено;
	КонецЕсли; 
	
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас"));
	
	Если ПараметрыПодбора = Неопределено Тогда
		ПараметрыПодбора = Новый Структура;
	КонецЕсли;
	
	ПараметрыПодбора.Вставить("Период", 							   Объект.Дата);
	ПараметрыПодбора.Вставить("ЭтоПриходныйДокумент",				   ЭтоПриходныйДокумент);
	ПараметрыПодбора.Вставить("ДоступноИзменениеЦены",				   Ложь);
	ПараметрыПодбора.Вставить("ТипНоменклатуры",				       СписокТипов);
	ПараметрыПодбора.Вставить("ПодконтрольнаяПродукцияВЕТИС",		   Истина);
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", Форма.УникальныйИдентификатор);
	
	Если ЗначениеЗаполнено(ДанныеХозяйствующегоСубъекта) И ДанныеХозяйствующегоСубъекта.СоответствуетОрганизации Тогда
		ПараметрыПодбора.Вставить("Организация", ДанныеХозяйствующегоСубъекта.Контрагент);
		ПараметрыПодбора.Вставить("ОрганизацияДокумента", ДанныеХозяйствующегоСубъекта.Контрагент);
	Иначе
		ПараметрыПодбора.Вставить("Организация", ПредопределенноеЗначение("Справочник.Организации.ОсновнаяОрганизация"));
		ПараметрыПодбора.Вставить("ОрганизацияДокумента", ПредопределенноеЗначение("Справочник.Организации.ОсновнаяОрганизация"));
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ИмяРеквизитаПодразделение) Тогда
		ПараметрыПодбора.Вставить("СтруктурнаяЕдиница", Объект[ИмяРеквизитаПодразделение]);
	КонецЕсли; 
	
	Если Не ЭтоПриходныйДокумент Тогда
		ПараметрыПодбора.Вставить("ВидЦен",  УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			ПользователиКлиентСервер.АвторизованныйПользователь(),
			"ОсновнойВидЦенПродажи"));
		Если Не ЗначениеЗаполнено(ПараметрыПодбора.ВидЦен) Тогда
			ПараметрыПодбора.Вставить("ВидЦен", ПредопределенноеЗначение("Справочник.ВидыЦен.Оптовая"));
		КонецЕсли;
		ПараметрыПодбора.Вставить("Валюта", УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеКонстанты("НациональнаяВалюта"));
		ПараметрыПодбора.Вставить("СуммаВключаетНДС", УправлениеНебольшойФирмойСервер.ЗначениеРеквизитаОбъекта(ПараметрыПодбора.ВидЦен, "ЦенаВключаетНДС"));
	КонецЕсли;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ИспользоватьНовуюФормуПодбораНоменклатуры") Тогда
		ИспользоватьНовуюФормуПодбораНоменклатуры = ДополнительныеПараметры.ИспользоватьНовуюФормуПодбораНоменклатуры;
	Иначе
		ИспользоватьНовуюФормуПодбораНоменклатуры = УправлениеНебольшойФирмойСервер.ПолучитьЗначениеКонстанты("ИспользоватьНовуюФормуПодбораНоменклатуры")
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ИспользоватьНовуюФормуПодбораНоменклатуры") Тогда
		Форма.ИспользоватьНовуюФормуПодбораНоменклатуры = ИспользоватьНовуюФормуПодбораНоменклатуры;
	КонецЕсли;
	
	Если ИспользоватьНовуюФормуПодбораНоменклатуры Тогда
		ПараметрыПодбора.Вставить("ЭтоМаркировка", Истина);
		ПодборНоменклатурыВДокументахКлиент.ОткрытьФормуПодбораНоменклатуры(Форма,, ПараметрыПодбора, ОповещениеПриЗавершении);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаПодбора", ПараметрыПодбора, Форма,,,, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Открывает форму выбора характеристики номенклатуры.
//
// Параметры:
//  Форма                 - УправляемаяФорма - форма, в которой вызывается команда выбора номенклатуры,
//  ПараметрыНоменклатуры - Структура        - параметры создания номенклатуры из формы выбора номенклатуры
//										(см. описание ИнтеграцияВЕТИСВызовСервера.ПараметрыНоменклатуры).
//
Процедура ОткрытьФормуВыбораНоменклатуры(Форма, ПараметрыНоменклатуры = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	Если ПараметрыНоменклатуры <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ПараметрыНоменклатуры Цикл
			ПараметрыФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ТипНоменклатуры  = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас");
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипНоменклатуры",					ТипНоменклатуры);
	ПараметрыОтбора.Вставить("ПодконтрольнаяПродукцияВЕТИС",	Истина);
	
	ПараметрыФормы.Вставить("Отбор",				ПараметрыОтбора);
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов",	ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("РежимВыбора",			Истина);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Форма);
	
КонецПроцедуры

// Открывает форму создания номенклатуры.
//
// Параметры:
//  Форма                 - УправляемаяФорма                       - форма, в которой вызывается команда создания номенклатуры,
//  ПараметрыНоменклатуры - Структура                              - параметры создания номенклатуры
//										(см. описание ИнтеграцияВЕТИСВызовСервера.ПараметрыНоменклатуры),
//  ЕдиницаИзмеренияВЕТИС - СправочникСсылка.ЕдиницыИзмеренияВЕТИС - единица измерения ВЕТИС, на основании которой 
//																		создается номенклатура.
//
Процедура ОткрытьФормуСозданияНоменклатуры(Форма, ПараметрыНоменклатуры, ЕдиницаИзмеренияВЕТИС) Экспорт
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС)
		И Не ЗначениеЗаполнено(ПараметрыНоменклатуры.ЕдиницаИзмеренияВЕТИС) Тогда
		
		ТекстСообщения = НСтр("ru = 'Невозможно создать номенклатуру, т.к. не заполнено поле ""Единица измерения"" в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВЕТИС%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВЕТИС%", Строка(ЕдиницаИзмеренияВЕТИС));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	
	Для Каждого КлючИЗначение Из ПараметрыНоменклатуры Цикл
		ПараметрыФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	ТипНоменклатуры  = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас");
	
	ПараметрыФормы.Вставить("ТипНоменклатуры",  ТипНоменклатуры);
	ПараметрыФормы.Вставить("ПодконтрольнаяПродукцияВЕТИС", Истина);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, Форма);
	
КонецПроцедуры

// Открывает форму создания нового контрагента.
//
// Параметры:
//  ФормаВладелец - УправляемаяФорма - форма-владелец.
//  Реквизиты     - Структура        - данные заполнения нового контрагента:
//   * Наименование            - Строка - наименование контрагента,
//   * СокращенноеНаименование - Строка - сокращенное наименование контрагента,
//   * ИНН                     - Строка - ИНН контрагента,
//   * КПП                     - Строка - КПП контрагента.
//
Процедура ОткрытьФормуСозданияКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	Основание = Новый Структура;
	Основание.Вставить("ИНН",					Реквизиты.ИНН);
	Основание.Вставить("КПП",					Реквизиты.КПП);
	Основание.Вставить("Наименование",			Реквизиты.СокращенноеНаименование);
	Основание.Вставить("НаименованиеПолное",	Реквизиты.Наименование);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("Основание", Основание);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Открывает форму выбора контрагента.
//
// Параметры:
//  ФормаВладелец - УправляемаяФорма - форма, из которой осуществляется выбор.
//  Реквизиты     - Структура        - данные для заполнения отбора:
//   * Наименование            - Строка - наименование контрагента,
//   * СокращенноеНаименование - Строка - сокращенное наименование контрагента,
//   * ИНН                     - Строка - ИНН контрагента,
//   * КПП                     - Строка - КПП контрагента.
//
Процедура ОткрытьФормуВыбораКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	Основание = Новый Структура;
	Основание.Вставить("ИНН",					Реквизиты.ИНН);
	Основание.Вставить("КПП",					Реквизиты.КПП);
	Основание.Вставить("Наименование",			Реквизиты.СокращенноеНаименование);
	Основание.Вставить("НаименованиеПолное",	Реквизиты.Наименование);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", Основание);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

Процедура ВыполнитьОперацииПриИзмененииРеквизитовФормы(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	Перем ПараметрыПересчетаКоличестваВЕТИС, ТекстОшибки;
	НужноОкруглять = Ложь;
	
	// ОбязательныеДействия
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Номенклатура") Тогда
		СтруктураРеквизитов = ИнтеграцияВЕТИСУНФВызовСервера.ПолучитьСтруктуруСлужебныхРеквизитовНоменклатуры(ТекущаяСтрока.Номенклатура);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураРеквизитов);
	КонецЕсли;
	// Конец ОбязательныеДействия
	
	Если ТипЗнч(ПараметрыЗаполнения) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("ЗаполнитьПродукциюВЕТИС") И ПараметрыЗаполнения.ЗаполнитьПродукциюВЕТИС Тогда
		
		СтруктураСтроки = ИнтеграцияВЕТИСУНФКлиентСервер.СформироватьСтруктуруПоСтроке(ТекущаяСтрока, "ЗаполнитьПродукциюВЕТИС");
		ИнтеграцияВЕТИСУНФВызовСервера.ЗаполнитьПродукциюВЕТИС(СтруктураСтроки, ПараметрыЗаполнения);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураСтроки);
		
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("ПересчитатьКоличествоЕдиницПоВЕТИС", ПараметрыПересчетаКоличестваВЕТИС)
		И ((ТипЗнч(ПараметрыПересчетаКоличестваВЕТИС) = Тип("Булево") И ПараметрыПересчетаКоличестваВЕТИС)
		ИЛИ ТипЗнч(ПараметрыПересчетаКоличестваВЕТИС) = Тип("Структура")) Тогда
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ЕдиницаИзмеренияВЕТИС") Тогда
			ЕдиницаИзмеренияВЕТИС = ТекущаяСтрока.ЕдиницаИзмеренияВЕТИС;
		Иначе
			ЕдиницаИзмеренияВЕТИС = ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС;
		КонецЕсли;
		
		// В ТЧ документов ВетИС реквизит с количеством ВетИС может называться по разному.
		Попытка
			Количество = ИнтеграцияВЕТИСУНФВызовСервера.ПересчитатьКоличествоЕдиниц(
												ТекущаяСтрока.КоличествоВЕТИС,
												ТекущаяСтрока.Номенклатура,
												ЕдиницаИзмеренияВЕТИС,
												НужноОкруглять,
												КэшированныеЗначения,
												ТекстОшибки
			);
		Исключение
			Количество = ИнтеграцияВЕТИСУНФВызовСервера.ПересчитатьКоличествоЕдиниц(
												ТекущаяСтрока.КоличествоИзменениеВЕТИС,
												ТекущаяСтрока.Номенклатура,
												ЕдиницаИзмеренияВЕТИС,
												НужноОкруглять,
												КэшированныеЗначения,
												ТекстОшибки
			);
		КонецПопытки;
		
		Если Количество <> Неопределено Тогда
			Попытка
				ТекущаяСтрока.Количество = Количество;
			Исключение
				ТекущаяСтрока.КоличествоИзменение = Количество;
			КонецПопытки;
		ИначеЕсли ТекстОшибки <> Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "КоличествоСтароеВЕТИС") Тогда
			
			КоличествоСтарое = ИнтеграцияВЕТИСУНФВызовСервера.ПересчитатьКоличествоЕдиниц(
				ТекущаяСтрока.КоличествоСтароеВЕТИС,
				ТекущаяСтрока.Номенклатура,
				ЕдиницаИзмеренияВЕТИС,
				НужноОкруглять,
				КэшированныеЗначения,
				ТекстОшибки);
			
			Если КоличествоСтарое <> Неопределено Тогда
				Попытка
					ТекущаяСтрока.КоличествоСтарое = КоличествоСтарое;
				Исключение
				КонецПопытки;
			ИначеЕсли ТекстОшибки <> Неопределено Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("ПересчитатьКоличествоЕдиницВЕТИС") И ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницВЕТИС Тогда
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ЕдиницаИзмеренияВЕТИС") Тогда
			ЕдиницаИзмеренияВЕТИС = ТекущаяСтрока.ЕдиницаИзмеренияВЕТИС;
		Иначе
			ЕдиницаИзмеренияВЕТИС = ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС;
		КонецЕсли; 
		
		КоличествоВЕТИС = ИнтеграцияВЕТИСУНФВызовСервера.ПересчитатьКоличествоЕдиницВЕТИС(
											ТекущаяСтрока.Количество,
											ТекущаяСтрока.Номенклатура,
											ЕдиницаИзмеренияВЕТИС,
											НужноОкруглять,
											КэшированныеЗначения,
											ТекстОшибки);
		
		Если КоличествоВЕТИС <> Неопределено Тогда
			ТекущаяСтрока.КоличествоВЕТИС = КоличествоВЕТИС;
		ИначеЕсли ТекстОшибки <> Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
	
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("ПроверитьСериюРассчитатьСтатус")
		И ((ТипЗнч(ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус) = Тип("Булево") И ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус)
		ИЛИ ТипЗнч(ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус) = Тип("Структура")) Тогда
		
		СтруктураСтроки = ИнтеграцияВЕТИСУНФКлиентСервер.СформироватьСтруктуруПоСтроке(ТекущаяСтрока, "ПроверитьСериюРассчитатьСтатус");
		ИнтеграцияВЕТИСУНФВызовСервера.ПроверитьСериюРассчитатьСтатус(ПараметрыЗаполнения, СтруктураСтроки);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураСтроки);
	
	КонецЕсли; 
	
	Если ПараметрыЗаполнения.Свойство("ПересчитатьКоличествоЕдиницВЕТИСПоЕдиницеИзмерения") И ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницВЕТИСПоЕдиницеИзмерения Тогда
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ЕдиницаИзмеренияВЕТИС") Тогда
			ЕдиницаИзмеренияВЕТИС = ТекущаяСтрока.ЕдиницаИзмеренияВЕТИС;
		Иначе
			ЕдиницаИзмеренияВЕТИС = ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС;
		КонецЕсли;
		
		КоличествоВЕТИС = ИнтеграцияВЕТИСУНФВызовСервера.ПересчитатьКоличествоЕдиницВЕТИС(
											ТекущаяСтрока.КоличествоВЕТИС,
											ТекущаяСтрока.Номенклатура,
											ЕдиницаИзмеренияВЕТИС,
											НужноОкруглять,
											КэшированныеЗначения,
											ТекстОшибки);
		
		Если КоличествоВЕТИС <> Неопределено Тогда
			ТекущаяСтрока.КоличествоВЕТИС = КоличествоВЕТИС;
		КонецЕсли;
	
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("ИзменениеНоменклатуры") И ПараметрыЗаполнения.ИзменениеНоменклатуры Тогда
		
		Если ТекущаяСтрока.Свойство("Характеристика") Тогда
			ТекущаяСтрока.Характеристика = Неопределено;
		КонецЕсли;
		
		ИнтеграцияВЕТИСУНФКлиентСервер.УстановитьВидимостьКомандыГенерацииСерии(Форма);
		
	КонецЕсли;
	
	Если Форма <> Неопределено Тогда
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при начале выбора характеристики в таблице Товары.
//
// Параметры:
//  Форма                - УправляемаяФорма            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  Элемент              - ПолеВвода                   - элемент формы Характеристика,
//  ДанныеВыбора         - СписокЗначений              - в обработчике можно сформировать и передать в этом параметре
//                                                       данные для выбора,
//  СтандартнаяОбработка - Булево                      - признак выполнения стандартной (системной) обработки события.
//
Процедура НачалоВыбораХарактеристики(Форма, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент <> Неопределено И Элемент.Имя = "ТоварыПредставлениеХарактеристика" Тогда
		ПараметрыФормыВыбора = Новый Структура;
		ПараметрыФормыВыбора.Вставить("Отбор", Новый Структура("Владелец", ТекущаяСтрока.Номенклатура));
		ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.ФормаВыбора", ПараметрыФормыВыбора, Элемент, Форма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УНФ

Процедура РазбитьСтрокуТЧВводЧисла(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения, ПараметрыОбработки)
	
	ТекущаяСтрока	= ЭлементФормы.ТекущиеДанные;
	
	Если ПараметрыОбработки.Количество = Неопределено Тогда
		Количество = ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество];
	Иначе
		Количество = ПараметрыОбработки.Количество;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТЧ",                       ТЧ);
	ДополнительныеПараметры.Вставить("ЭлементФормы",             ЭлементФормы);
	ДополнительныеПараметры.Вставить("ОповещениеПослеРазбиения", ОповещениеПослеРазбиения);
	ДополнительныеПараметры.Вставить("ПараметрыОбработки",       ПараметрыОбработки);
	
	Оповещение = Новый ОписаниеОповещения(
		"РазбитьСтрокуТЧПослеВводаЧисла", 
		ЭтотОбъект,
		ДополнительныеПараметры);
	ПоказатьВводЧисла(Оповещение, Количество, ПараметрыОбработки.Заголовок, 15, 3);

КонецПроцедуры

Процедура РазбитьСтрокуТЧДобавлениеСтроки(ТЧ, ЭлементФормы, Количество, ОповещениеПослеРазбиения, ПараметрыОбработки)
	
	ТекущаяСтрока	= ЭлементФормы.ТекущиеДанные;
	
	ИндексТекущейСтроки 	 = ТЧ.Индекс(ТекущаяСтрока);
	НоваяСтрока 			 = ТЧ.Вставить(ИндексТекущейСтроки + 1);
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	
	НоваяСтрока[ПараметрыОбработки.ИмяПоляКоличество]   = Количество;
	ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] = ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество]
		- НоваяСтрока[ПараметрыОбработки.ИмяПоляКоличество];
	
	Если ОповещениеПослеРазбиения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, НоваяСтрока);
	КонецЕсли; 
	
	ЭлементФормы.ТекущаяСтрока  = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

// Служебная процедура.
//
Процедура РазбитьСтрокуТЧПослеВводаЧисла(Количество, ДополнительныеПараметры) Экспорт
	
	ТЧ                       = ДополнительныеПараметры.ТЧ;
	ЭлементФормы             = ДополнительныеПараметры.ЭлементФормы;
	ОповещениеПослеРазбиения = ДополнительныеПараметры.ОповещениеПослеРазбиения;
	ПараметрыОбработки       = ДополнительныеПараметры.ПараметрыОбработки;
	
	ТекущаяСтрока            = ЭлементФормы.ТекущиеДанные;
	
	ЧислоВведено = Количество <> Неопределено;
	
	Если Не ЧислоВведено Тогда
		Если ОповещениеПослеРазбиения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПослеРазбиения, Неопределено);
		КонецЕсли;
		Возврат;
	ИначеЕсли Количество = 0
		И Не ПараметрыОбработки.РазрешитьНулевоеКоличество Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть равно нулю.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] >= 0
		И Количество < 0 Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть отрицательным.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] <= 0
		И Количество > 0 Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть положительным.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] >= 0
		И Количество >  ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть больше количества в текущей.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] <= 0
		И Количество <  ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество] Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке не может быть меньше количества в текущей.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	ИначеЕсли Количество =  ТекущаяСтрока[ПараметрыОбработки.ИмяПоляКоличество]
		И Не ПараметрыОбработки.РазрешитьНулевоеКоличество Тогда
		ТекстСообщения = НСтр("ru = 'Количество в новой строке должно отличаться от количества в текущей.'");
		Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧПослеПредупреждения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(Оповещение,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	РазбитьСтрокуТЧДобавлениеСтроки(ТЧ, ЭлементФормы, Количество, ОповещениеПослеРазбиения, ПараметрыОбработки);
	
КонецПроцедуры

// Служебная процедура.
//
Процедура РазбитьСтрокуТЧПослеПредупреждения(ДополнительныеПараметры) Экспорт
	
	ТЧ                       = ДополнительныеПараметры.ТЧ;
	ЭлементФормы             = ДополнительныеПараметры.ЭлементФормы;
	ОповещениеПослеРазбиения = ДополнительныеПараметры.ОповещениеПослеРазбиения;
	ПараметрыОбработки       = ДополнительныеПараметры.ПараметрыОбработки;
	
	РазбитьСтрокуТЧВводЧисла(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения, ПараметрыОбработки);
	
КонецПроцедуры

Процедура ЗаполнитьВыбранныеТовары(Форма, ИмяТабличнойЧасти, АдресЗапасовВХранилище) Экспорт
	
	ОтобранныеЗапасы = Новый Массив;
	ИнтеграцияВЕТИСУНФВызовСервера.ПолучитьЗапасыИзХранилища(ОтобранныеЗапасы, АдресЗапасовВХранилище, ИмяТабличнойЧасти);
	
	Для каждого СтрокаЗапасов Из ОтобранныеЗапасы Цикл
		НоваяСтрока = Форма.Объект[ИмяТабличнойЧасти].Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
	КонецЦикла; 
	
КонецПроцедуры

Функция СгенерироватьШаблонНаименованияПартии(Объект) Экспорт
	
	Если Не Объект.АвтоматическиГенерироватьПартии Тогда
		Возврат "";
	КонецЕсли;
	
	ЧастиНаименования = Новый Массив;
	
	Если Объект.ИспользоватьСрокГодностиПартии Тогда
		ЧастиНаименования.Добавить(НСтр("ru = 'до 31.12.2019'"));
	КонецЕсли;
	
	Если Объект.ИспользоватьДатуПроизводстваПартии Тогда
		ЧастиНаименования.Добавить(НСтр("ru = 'от 01.02.2018'"));
	КонецЕсли;
	
	Если Объект.ИспользоватьЗаписьСкладскогоЖурналаВЕТИСПартии Тогда
		ЧастиНаименования.Добавить(НСтр("ru = '10208756'"));
	КонецЕсли;
	
	Если Объект.ИспользоватьПроизводителяВЕТИСПартии Тогда
		ЧастиНаименования.Добавить(ИнтеграцияВЕТИСУНФВызовСервера.НаименованиеОрганизацииПоУмолчанию());
	КонецЕсли;
	
	Если Объект.ИспользоватьИдентификаторПартииВЕТИСПартии Тогда
		ЧастиНаименования.Добавить(НСтр("ru = '2505181'"));
	КонецЕсли;
	
	Если ЧастиНаименования.Количество() = 0 Тогда
		ЧастиНаименования.Добавить(НСтр("ru = '""Сгенерирована автоматически""'"));
	КонецЕсли;
	
	Возврат СтрШаблон("%1: %2", "Пример наименования", СтрСоединить(ЧастиНаименования, " "));
	
КонецФункции

#КонецОбласти

