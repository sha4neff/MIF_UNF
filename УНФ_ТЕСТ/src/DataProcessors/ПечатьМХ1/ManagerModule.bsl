#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ServiceAPI

Функция ИдентификаторПечатнойФормы() Экспорт

	Возврат "МХ1";

КонецФункции

Функция КлючПараметровПечати() Экспорт

	Возврат "ПАРАМЕТРЫ_ПЕЧАТИ_Универсальные_МХ1";

КонецФункции

Функция ПолныйПутьКМакету() Экспорт

	Возврат "Обработка.ПечатьМХ1.ПФ_MXL_МХ1";

КонецФункции

Функция ПредставлениеПФ() Экспорт

	Возврат НСтр("ru ='МХ-1 (Акт о приеме-передаче запасов на хранение)'");

КонецФункции

Функция СформироватьПФ(ОписаниеПечатнойФормы, ДанныеОбъектовПечати, ОбъектыПечати) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;

	Макет = УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент = ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати = Новый Структура;
	ЕстьТЧЗапасы = (ДанныеОбъектовПечати.Колонки.Найти("ТаблицаЗапасы") <> Неопределено);

	Для Каждого ДанныеОбъекта Из ДанныеОбъектовПечати Цикл

		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало,
			ДанныеПечати);

		СведенияОбОрганизации = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ДанныеОбъекта.Организация,
			ДанныеОбъекта.ДатаДокумента, , );
		СведенияОбКонтрагенте = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ДанныеОбъекта.Контрагент,
			ДанныеОбъекта.ДатаДокумента, , );
		
		// Заголовок
		ОбластьЗаголовок = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Заголовок", "", Ошибки);
		Если ОбластьЗаголовок <> Неопределено Тогда

			ДанныеПечати.Вставить("НомерДокумента", ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(
				ДанныеОбъекта.ДатаДокумента, ДанныеОбъекта.Номер, ДанныеОбъекта.Префикс));
			ДанныеПечати.Вставить("ДатаДокумента", Формат(ДанныеОбъекта.ДатаДокумента, "ДЛФ=D"));
			ДанныеПечати.Вставить("ВидОперации", ДанныеОбъекта.ВидОперации);
			ДанныеПечати.Вставить("ПредставлениеОрганизации", УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(
				СведенияОбОрганизации, "ПолноеНаименование,ЮридическийАдрес,Телефон,Факс"));
			ДанныеПечати.Вставить("ОрганизацияПоОКПО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ДанныеОбъекта.Организация, "КодПоОКПО"));

			ДанныеПечати.Вставить("ПредставлениеПодразделения", ДанныеОбъекта.ПредставлениеПодразделения);
			ДанныеПечати.Вставить("ПредставлениеСклада", ДанныеОбъекта.ПредставлениеСклада);
			ДанныеПечати.Вставить("СрокХранения", ДанныеОбъекта.СрокХранения);
			ДанныеПечати.Вставить("ПредставлениеКонтрагента", УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(
				СведенияОбКонтрагенте, "ПолноеНаименование,ЮридическийАдрес,Телефон,Факс"));
			ДанныеПечати.Вставить("ПоклажедательПоОКПО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ДанныеОбъекта.Контрагент, "КодПоОКПО"));

			ДанныеПечати.Вставить("РасшифровкаПодписиКонтрагента", ДанныеОбъекта.РасшифровкаПодписиКонтрагента);
			ДанныеПечати.Вставить("ДоговорНомер", ДанныеОбъекта.ДоговорНомер);
			ДанныеПечати.Вставить("ДоговорДата", ДанныеОбъекта.ДоговорДата);

			ОбластьЗаголовок.Параметры.Заполнить(ДанныеПечати);
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок,
				ДанныеОбъекта.Ссылка);
			ТабличныйДокумент.Вывести(ОбластьЗаголовок);

		КонецЕсли;
		
		// Табличная часть
		НомерСтраницы = 1;

		ОбластьМакетаШапкаТаблицы = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ШапкаТаблицы", "", Ошибки);
		Если ОбластьМакетаШапкаТаблицы <> Неопределено Тогда

			ДанныеПечати.Вставить("НомерСтраницы", СтрШаблон(НСтр("ru ='Страница %1'"), НомерСтраницы));

			ОбластьМакетаШапкаТаблицы.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакетаШапкаТаблицы);

		КонецЕсли;

		Итоги = Новый Структура;
		Итоги.Вставить("НомерСтроки", 0);
		Итоги.Вставить("КоличествоПоСтранице", 0);
		Итоги.Вставить("КоличествоПоАкту", 0);
		Итоги.Вставить("СуммаПоСтранице", 0);
		Итоги.Вставить("СуммаПоАкту", 0);
		Итоги.Вставить("ОсталосьВывестиСтрок", 0);

		ОбластиМакета = Новый Структура;
		ОбластиМакета.Вставить("ОбластьМакетаСтрока", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Строка", "",
			Ошибки));
		ОбластиМакета.Вставить("ОбластьМакетаИтоговПоСтранице", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(
			Макет, "ИтогоПоСтранице", "", Ошибки));
		ОбластиМакета.Вставить("ОбластьМакетаВсего", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Всего", "",
			Ошибки));
		ОбластиМакета.Вставить("ОбластьМакетаШапкаТаблицы", ОбластьМакетаШапкаТаблицы);
		ОбластиМакета.Вставить("ОбластьМакетаДетализацияХранения", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет,
			"ДетализацияХранения", "", Ошибки));
		ОбластиМакета.Вставить("ОбластьМакетаПодписи", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Подписи", ,
			Ошибки));

		Если ОбластиМакета.ОбластьМакетаСтрока <> Неопределено Тогда

			Если ЕстьТЧЗапасы Тогда

				ПараметрыПроверки = Новый Структура;
				ПараметрыПроверки.Вставить("ОбластиМакета", ОбластиМакета);
				ПараметрыПроверки.Вставить("Итоги", Итоги);
				ПараметрыПроверки.Вставить("НомерСтраницы", НомерСтраницы);

				ПараметрыНоменклатуры = Новый Структура;
				Итоги.ОсталосьВывестиСтрок = КоличествоСтрокКВыводуНаПечать(ДанныеОбъекта);

				ПараметрыНоменклатуры = Новый Структура;
				Для Каждого СтрокаТабличнойЧасти Из ДанныеОбъекта.ТаблицаЗапасы Цикл

					Если СтрокаТабличнойЧасти.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда
						Продолжить;
					КонецЕсли;

					Если СтрокаТабличнойЧасти.Количество = 0 Тогда
						Продолжить;
					КонецЕсли;

					Итоги.ОсталосьВывестиСтрок = Итоги.ОсталосьВывестиСтрок - 1;

					ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати,
						ПараметрыНоменклатуры, Итоги, ДанныеОбъекта);

					ОбластиМакета.ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати);

					СтрокаПоместиласьНаСтранице(ТабличныйДокумент, ПараметрыПроверки);

					ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаСтрока);

				КонецЦикла;

			КонецЕсли;

		КонецЕсли;
		
		// Итого по странице
		Если ОбластиМакета.ОбластьМакетаИтоговПоСтранице <> Неопределено Тогда

			ДанныеПечати.Вставить("КоличествоПоСтранице", Итоги.КоличествоПоСтранице);
			ДанныеПечати.Вставить("СуммаПоСтранице", УправлениеНебольшойФирмойСервер.ФорматСумм(
				Итоги.СуммаПоСтранице));

			ОбластиМакета.ОбластьМакетаИтоговПоСтранице.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаИтоговПоСтранице);

		КонецЕсли;
		
		// Всего
		Если ОбластиМакета.ОбластьМакетаВсего <> Неопределено Тогда

			ДанныеПечати.Вставить("КоличествоПоАкту", Итоги.КоличествоПоАкту);
			ДанныеПечати.Вставить("СуммаПоАкту", УправлениеНебольшойФирмойСервер.ФорматСумм(
				Итоги.СуммаПоАкту));

			ОбластиМакета.ОбластьМакетаВсего.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаВсего);

		КонецЕсли;
		
		// Детализация хранения
		Если ОбластиМакета.ОбластьМакетаДетализацияХранения <> Неопределено Тогда

			ОбластиМакета.ОбластьМакетаДетализацияХранения.Параметры.Заполнить(ДанныеОбъекта);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаДетализацияХранения);

		КонецЕсли;
		
		//Подписи
		Если ОбластиМакета.ОбластьМакетаПодписи <> Неопределено Тогда

			ОбластиМакета.ОбластьМакетаПодписи.Параметры.Заполнить(ДанныеОбъекта);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаПодписи);

		КонецЕсли;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеОбъекта.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти

Процедура СтрокаПоместиласьНаСтранице(ТабличныйДокумент, ПараметрыПроверки)

	МассивВыводимыхОбластей = Новый Массив;
	МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.ОбластиМакета.ОбластьМакетаСтрока);
	МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.ОбластиМакета.ОбластьМакетаИтоговПоСтранице);

	Если ПараметрыПроверки.Итоги.ОсталосьВывестиСтрок = 0 Тогда

		МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.ОбластиМакета.ОбластьМакетаВсего);
		МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.ОбластиМакета.ОбластьМакетаДетализацияХранения);
		МассивВыводимыхОбластей.Добавить(ПараметрыПроверки.ОбластиМакета.ОбластьМакетаПодписи);

	КонецЕсли;

	Если Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда

		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("СуммаПоСтранице", УправлениеНебольшойФирмойСервер.ФорматСумм(
			ПараметрыПроверки.Итоги.СуммаПоСтранице));

		ПараметрыПроверки.ОбластиМакета.ОбластьМакетаИтоговПоСтранице.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ПараметрыПроверки.ОбластиМакета.ОбластьМакетаИтоговПоСтранице);

		ПараметрыПроверки.Итоги.СуммаПоСтранице = 0;
		ПараметрыПроверки.Итоги.КоличествоПоСтранице = 0;

		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();

		ПараметрыПроверки.НомерСтраницы = ПараметрыПроверки.НомерСтраницы + 1;
		ДанныеПечати.Вставить("НомерСтраницы", НСтр("ru ='Страница '") + ПараметрыПроверки.НомерСтраницы);

		ПараметрыПроверки.ОбластиМакета.ОбластьМакетаШапкаТаблицы.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ПараметрыПроверки.ОбластиМакета.ОбластьМакетаШапкаТаблицы);

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати, ПараметрыНоменклатуры, Итоги,
	ДанныеОбъекта)

	ДанныеПечати.Очистить();

	Итоги.НомерСтроки = Итоги.НомерСтроки + 1;
	ДанныеПечати.Вставить("НомерСтроки", Итоги.НомерСтроки);

	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("Содержание", СтрокаТабличнойЧасти.Содержание);
	ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаТабличнойЧасти.ПредставлениеНоменклатуры);
	ПараметрыНоменклатуры.Вставить("ПредставлениеПартии", СтрокаТабличнойЧасти.Партия);
	ДанныеПечати.Вставить("ПредставлениеНоменклатуры", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(
		ПараметрыНоменклатуры));
	ДанныеПечати.Вставить("ПредставлениеКодаНоменклатуры", ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(
		СтрокаТабличнойЧасти));

	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаТабличнойЧасти.Характеристика);
	ДанныеПечати.Вставить("ПредставлениеХарактеристики", ПечатьДокументовУНФ.СтрокаПредставленияХарактеристики(
		ПараметрыНоменклатуры));

	ДанныеПечати.Вставить("Количество", СтрокаТабличнойЧасти.КоличествоПоКоэффициенту);
	ДанныеПечати.Вставить("ЕдиницаИзмерения", СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Наименование",
		СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Наименование);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Код", СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Код);

	СуммаКПечати = ?(ДанныеОбъекта.СуммаВключаетНДС, СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте,
		СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте - СтрокаТабличнойЧасти.СуммаНДСВНациональнойВалюте);
	ДанныеПечати.Вставить("Цена",
	УправлениеНебольшойФирмойСервер.ФорматСумм(Окр(СуммаКПечати / СтрокаТабличнойЧасти.КоличествоПоКоэффициенту, 2)));
	ДанныеПечати.Вставить("Сумма", УправлениеНебольшойФирмойСервер.ФорматСумм(
		СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте));

	Итоги.КоличествоПоСтранице = Итоги.КоличествоПоСтранице + СтрокаТабличнойЧасти.КоличествоПоКоэффициенту;
	Итоги.КоличествоПоАкту = Итоги.КоличествоПоАкту + СтрокаТабличнойЧасти.КоличествоПоКоэффициенту;
	Итоги.СуммаПоСтранице = Итоги.СуммаПоСтранице + СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте;
	Итоги.СуммаПоАкту = Итоги.СуммаПоАкту + СтрокаТабличнойЧасти.ВсегоВНациональнойВалюте;

КонецПроцедуры

Функция КоличествоСтрокКВыводуНаПечать(ДанныеОбъекта)

	КоличествоРезультирующихСтрок = 0;

	Для Каждого СтрокаТаблицы Из ДанныеОбъекта.ТаблицаЗапасы Цикл

		Если СтрокаТаблицы.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда

			Продолжить;

		КонецЕсли;

		КоличествоРезультирующихСтрок = КоличествоРезультирующихСтрок + 1;

	КонецЦикла;

	Возврат КоличествоРезультирующихСтрок;

КонецФункции

#КонецЕсли