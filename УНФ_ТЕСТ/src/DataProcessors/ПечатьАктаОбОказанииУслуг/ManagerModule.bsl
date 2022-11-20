
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ServiceAPI

Функция ИдентификаторПечатнойФормы(Подробно = Ложь, ИспользоватьФаксимиле = Ложь) Экспорт
	
	Возврат ?(Подробно, "АктОбОказанииУслугПодробно", "АктОбОказанииУслуг") + ?(ИспользоватьФаксимиле, "Факсимиле", "");
	
КонецФункции

Функция ПредставлениеПФ(Подробно = Ложь, ИспользоватьФаксимиле = Ложь) Экспорт
	
	ПредставлениеПФ = НСтр("ru ='Акт об оказании услуг'");
	
	ДополнительноеПредставление = "";
	Если Подробно Тогда
		
		ДополнительноеПредставление = НСтр("ru ='подробно'");
		
	КонецЕсли;
	
	Если ИспользоватьФаксимиле Тогда
		
		ДополнительноеПредставление = ДополнительноеПредставление + ?(Подробно, ", ", "") + НСтр("ru ='факсимиле'");
		
	КонецЕсли;
	
	Если Подробно
		ИЛИ ИспользоватьФаксимиле Тогда
		
		ДополнительноеПредставление = НСтр("ru =' ('") + ДополнительноеПредставление + НСтр("ru =')'");
		
	КонецЕсли;
	
	Возврат ПредставлениеПФ + ДополнительноеПредставление;
	
КонецФункции

Функция МатрицаВозможныхВариантов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ЛОЖЬ Подробно, ЛОЖЬ ИспользоватьФаксимиле
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ Ложь, ИСТИНА
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ Истина, ЛОЖЬ
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ Истина, ИСТИНА";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция КлючПараметровПечати() Экспорт
	
	Возврат "ПАРАМЕТРЫ_ПЕЧАТИ_Универсальные_АктОбОказанииУслуг";
	
КонецФункции

Функция ПолныйПутьКМакету(Подробно = Ложь) Экспорт
	
	Если Подробно Тогда
		Возврат "Обработка.ПечатьАктаОбОказанииУслуг.ПФ_MXL_АктОбОказанииУслугПодробно";
	Иначе
		Возврат "Обработка.ПечатьАктаОбОказанииУслуг.ПФ_MXL_АктОбОказанииУслуг";
	КонецЕсли;
	
КонецФункции

Функция СформироватьПФ(ОписаниеПечатнойФормы, ДанныеОбъектовПечати, ОбъектыПечати, Подробно) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;

	Макет = УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент = ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати = Новый Структура;
	ПредставлениеСкидки = Константы.ПредставлениеСкидкиВПечатнойФорме.Получить();

	Для Каждого ДанныеОбъекта Из ДанныеОбъектовПечати Цикл

		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало,
			ДанныеПечати);

		СведенияОбОрганизации = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ДанныеОбъекта.Организация,
			ДанныеОбъекта.ДатаДокумента, , );
		СведенияОбКонтрагенте = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ДанныеОбъекта.Контрагент,
			ДанныеОбъекта.ДатаДокумента, , );

		ЛоготипЗаполнен = ЗначениеЗаполнено(ДанныеОбъекта.ФайлЛоготип);
		ИмяМакета = ?(ЛоготипЗаполнен, "ЗаголовокСЛоготипом", "Заголовок");

		ОбластьЗаголовок = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, ИмяМакета, "", Ошибки);
		Если ОбластьЗаголовок <> Неопределено Тогда

			ШаблонЗаголовка = Нстр("ru ='Акт об оказании услуг № %1 от %2'");
			НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ДанныеОбъекта.ДатаДокумента,
				ДанныеОбъекта.Номер, ДанныеОбъекта.Префикс);
			ДанныеПечати.Вставить("ПредставлениеДокумента", СтрШаблон(ШаблонЗаголовка, НомерДокумента, Формат(
				ДанныеОбъекта.ДатаДокумента, "ДЛФ=DD")));

			Если ЛоготипЗаполнен Тогда

				ДанныеКартинки = РаботаСФайлами.ДвоичныеДанныеФайла(ДанныеОбъекта.ФайлЛоготип);
				Если ЗначениеЗаполнено(ДанныеКартинки) Тогда

					ОбластьЗаголовок.Рисунки.Логотип.Картинка = Новый Картинка(ДанныеКартинки);

				КонецЕсли;

			КонецЕсли;

			ОбластьЗаголовок.Параметры.Заполнить(ДанныеПечати);
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок,
				ДанныеОбъекта.Ссылка);
			ТабличныйДокумент.Вывести(ОбластьЗаголовок);

		КонецЕсли;

		ОбластьПоставщик = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Поставщик", "", Ошибки);
		Если ОбластьПоставщик <> Неопределено Тогда

			ДанныеПечати.Вставить("ПредставлениеПоставщика", УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(
				СведенияОбОрганизации, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,"));
			ДанныеПечати.Вставить("ОснованиеПечати", ДанныеОбъекта.ОснованиеПечати);

			ОбластьПоставщик.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьПоставщик);

		КонецЕсли;

		ОбластьПокупатель = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Покупатель", "", Ошибки);
		Если ОбластьПокупатель <> Неопределено Тогда

			ДанныеПечати.Вставить("ПредставлениеПолучателя", УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(
				СведенияОбКонтрагенте, "ПолноеНаименование,ИНН,КПП,РегистрационныйНомер,ЮридическийАдрес,Телефоны,"));

			ОбластьПокупатель.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьПокупатель);

		КонецЕсли;

		ЕстьСкидки = (ДанныеОбъекта.ТаблицаРаботыУслуги.Итог("ЕстьСкидка") <> 0);

		ИмяОбласти = ?(ЕстьСкидки, "ШапкаТаблицыСоСкидкой", "ШапкаТаблицы");
		ОбластьШапкаТаблицы = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, ИмяОбласти, "", Ошибки);
		Если ОбластьШапкаТаблицы <> Неопределено Тогда

			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);

		КонецЕсли;

		ИмяОбласти = ?(ЕстьСкидки, "СтрокаСоСкидкой", "Строка");
		ОбластьСтрока = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, ИмяОбласти, "", Ошибки);
		Если ОбластьСтрока <> Неопределено Тогда

			Итоги = Новый Структура;
			Итоги.Вставить("Сумма", 0);
			Итоги.Вставить("СуммаНДС", 0);
			Итоги.Вставить("Всего", 0);
			Итоги.Вставить("Количество", 0);
			Итоги.Вставить("НомерСтроки", 0);
			Итоги.Вставить("ПредставлениеСкидки", ПредставлениеСкидки);
			Итоги.Вставить("ЕстьСкидки", ЕстьСкидки);
			Итоги.Вставить("Подробно", Подробно);
			Итоги.Вставить("ЕстьСтавкаНольПроцентов", Ложь);
			
			// Наборы
			Итоги.Вставить("ЕстьНаборы", ДанныеОбъекта.ТаблицаРаботыУслуги.Колонки.Найти("НоменклатураНабора")
				<> Неопределено);
			Если Итоги.ЕстьНаборы Тогда
				// Наборы неподходящего типа разворачиваем до составляющих
				РазвернутьНабор = Ложь;
				Для Каждого СтрокаРаботыУслуги Из ДанныеОбъекта.ТаблицаРаботыУслуги Цикл
					Если СтрокаРаботыУслуги.ЭтоНабор И СтрокаРаботыУслуги.ТипНоменклатуры
						<> Перечисления.ТипыНоменклатуры.Услуга И СтрокаРаботыУслуги.ТипНоменклатуры
						<> Перечисления.ТипыНоменклатуры.Работа Тогда
						РазвернутьНабор = Истина;
						Продолжить;
					КонецЕсли;
					Если РазвернутьНабор И Не ЗначениеЗаполнено(СтрокаРаботыУслуги.НоменклатураНабора) Тогда
						РазвернутьНабор = Ложь;
					КонецЕсли;
					Если РазвернутьНабор Тогда
						СтрокаРаботыУслуги.НоменклатураНабора = Неопределено;
						СтрокаРаботыУслуги.ХарактеристикаНабора = Неопределено;
						СтрокаРаботыУслуги.НеобходимоВыделитьКакСоставНабора = Ложь;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли; 
			// Конец Наборы

			ПараметрыНоменклатуры = Новый Структура;

			Для Каждого СтрокаРаботыУслуги Из ДанныеОбъекта.ТаблицаРаботыУслуги Цикл

				Если СтрокаРаботыУслуги.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Услуга
					И СтрокаРаботыУслуги.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Работа Тогда

					Продолжить;

				КонецЕсли;

				ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаРаботыУслуги, ДанныеПечати, ПараметрыНоменклатуры,
					Итоги);
				ОбластьСтрока.Параметры.Заполнить(ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
				// Наборы
				Если Итоги.ЕстьНаборы Тогда
					НаборыСервер.УчестьОформлениеСтрокиНабора(ТабличныйДокумент, ОбластьСтрока, СтрокаРаботыУслуги);
				КонецЕсли;
				// Конец Наборы

			КонецЦикла;

		КонецЕсли;

		ОбластьИтого = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Итого", "", Ошибки);
		Если ОбластьИтого <> Неопределено Тогда

			ДанныеПечати.Вставить("Всего", УправлениеНебольшойФирмойСервер.ФорматСумм(Итоги.Сумма));
			ДанныеПечати.Вставить("ЗаголовокНДС", ПечатьДокументовУНФ.ПредставлениеЗаголовкаНДС(
				Итоги.СуммаНДС, ДанныеОбъекта.СуммаВключаетНДС, Ложь,
				Итоги.ЕстьСтавкаНольПроцентов));
			ДанныеПечати.Вставить("ВсегоНДС", ?(Итоги.СуммаНДС = 0
				И Не Итоги.ЕстьСтавкаНольПроцентов, "-", УправлениеНебольшойФирмойСервер.ФорматСумм(
				Итоги.СуммаНДС, , "0,00")));

			ОбластьИтого.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьИтого);

		КонецЕсли;

		ОбластьСуммаПрописью = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "СуммаПрописью", "", Ошибки);
		Если ОбластьСуммаПрописью <> Неопределено Тогда

			ШаблонИтоговойСтроки = НСтр("ru ='Всего наименований %1, на сумму %2'");
			ДанныеПечати.Вставить("ИтоговаяСтрока", СтрШаблон(ШаблонИтоговойСтроки, Строка(Итоги.Количество),
				УправлениеНебольшойФирмойСервер.ФорматСумм(Итоги.Всего, ДанныеОбъекта.ВалютаДокумента)));
			ДанныеПечати.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(Итоги.Всего,
				ДанныеОбъекта.ВалютаДокумента));
			ОбластьСуммаПрописью.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);

		КонецЕсли;

		ИмяОбласти = ?(ДанныеОбъекта.ИспользоватьФаксимиле = Перечисления.ДаНет.Да, "ПодписиСФаксимиле",
			"ПодписиБезФаксимиле");
		ОбластьПодписи = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, ИмяОбласти, , Ошибки);
		Если ОбластьПодписи <> Неопределено Тогда

			ОбластьПодписи.Параметры.Заполнить(ДанныеОбъекта);

			Если ДанныеОбъекта.ИспользоватьФаксимиле = Перечисления.ДаНет.Да Тогда

				ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
				ПодписиИФаксимиле.Вставить("ПодписьРуководителя", "ФаксимилеРуководителя");
				ПодписиИФаксимиле.Вставить("ПечатьОрганизации", "ФаксимилеПечати");

				ПодписьДокументовУНФ.ЗаполнитьФаксимилеВОбластиМакета(ОбластьПодписи, ДанныеОбъекта, ПодписиИФаксимиле,
					Ошибки);

			КонецЕсли;

			ТабличныйДокумент.Вывести(ОбластьПодписи);

		КонецЕсли;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеОбъекта.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти

Процедура ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати, ПараметрыНоменклатуры, Итоги)

	ДанныеПечати.Очистить();

	Если Итоги.ЕстьНаборы И СтрокаТабличнойЧасти.ЭтоНабор = Истина Тогда
		НомерСтроки = 0;
	Иначе
		Итоги.НомерСтроки = Итоги.НомерСтроки + 1;
		НомерСтроки = Итоги.НомерСтроки;
	КонецЕсли;
	ДанныеПечати.Вставить("НомерСтроки", НомерСтроки);

	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("Содержание", СтрокаТабличнойЧасти.Содержание);
	ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаТабличнойЧасти.ПредставлениеНоменклатуры);
	ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаТабличнойЧасти.Характеристика);
	// Наборы
	Если Итоги.ЕстьНаборы Тогда
		ПараметрыНоменклатуры.Вставить("НеобходимоВыделитьКакСоставНабора",
			СтрокаТабличнойЧасти.НеобходимоВыделитьКакСоставНабора);
	КонецЕсли;

	ДанныеПечати.Вставить("ПредставлениеНоменклатуры", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(
		ПараметрыНоменклатуры));
	ДанныеПечати.Вставить("Количество", СтрокаТабличнойЧасти.Количество);
	ДанныеПечати.Вставить("ЕдиницаИзмерения", СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	ДанныеПечати.Вставить("Цена", СтрокаТабличнойЧасти.Цена);

	Если Итоги.Подробно Тогда

		ДанныеПечати.Вставить("Время", СтрокаТабличнойЧасти.Время);
		ДанныеПечати.Вставить("Кратность", СтрокаТабличнойЧасти.Кратность);
		ДанныеПечати.Вставить("Коэффициент", СтрокаТабличнойЧасти.Коэффициент);

	КонецЕсли;

	Если Итоги.ЕстьСкидки Тогда

		ДанныеПечати.Вставить("ПредставлениеСкидки", ПечатьДокументовУНФ.ПредставлениеСкидки(СтрокаТабличнойЧасти,
			Итоги));

	КонецЕсли;

	ДанныеПечати.Вставить("Сумма", СтрокаТабличнойЧасти.Сумма);

	Если Итоги.ЕстьСтавкаНольПроцентов = Ложь // Нет смысла проверять каждую строку, если уже нашли...

		И СтрокаТабличнойЧасти.Владелец().Колонки.Найти("СтавкаНДС") <> Неопределено
		И СтрокаТабличнойЧасти.СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль() Тогда

		Итоги.ЕстьСтавкаНольПроцентов = Истина;

	КонецЕсли;
	
	Если Не Итоги.ЕстьНаборы Или Не СтрокаТабличнойЧасти.ЭтоНабор Тогда
		Итоги.Количество = Итоги.Количество + 1;
		Итоги.Сумма		= Итоги.Сумма + СтрокаТабличнойЧасти.Сумма;
		Итоги.СуммаНДС	= Итоги.СуммаНДС + СтрокаТабличнойЧасти.СуммаНДС;
		Итоги.Всего		= Итоги.Всего + СтрокаТабличнойЧасти.Всего;
	КонецЕсли;

КонецПроцедуры
 
#КонецЕсли