
#Область ПрограммныйИнтерфейс

// Процедура формирует наименование элемента справочника по значению других реквизитов.
//
Функция УстановитьНаименованиеДисконтнойКарты(Владелец, ВладелецКарты, КодКартыШтрихкод, КодКартыМагнитный) Экспорт

	Если Владелец.ТипКарты = Перечисления.ТипыКарт.Смешанная Тогда
		КодКартыСтр = СокрЛП(КодКартыШтрихкод) + " / " + СокрЛП(КодКартыМагнитный);
	ИначеЕсли Владелец.ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
		КодКартыСтр = СокрЛП(КодКартыМагнитный);
	Иначе
		КодКартыСтр = СокрЛП(КодКартыШтрихкод);
	КонецЕсли;
	
	ТекНаименование = "" + ?(ВладелецКарты.Пустая() ИЛИ Не Владелец.ЭтоИменнаяКарта, "", ""+ВладелецКарты+". ") +
	                      ?(Владелец.Пустая(), "", ""+Владелец+". ")
						  + КодКартыСтр;
						  
	Возврат ТекНаименование;

КонецФункции // ПолучитьНаименованиеДисконтнойКарты()

#Область ПоискДисконтныхКарт

// Функция выполняет поиск дисконтных карт по данным, полученным из считывателя
// магнитных карт
//
// Параметры
//  Данные - Массив данных, полученный из считывателя магнитных карт.
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные дисконтные карты
//  и НеЗарегистрированныеДисконтныеКарты.
//
Функция НайтиДисконтныеКартыПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗарегистрированныеДисконтныеКарты = Новый Массив;
	НеЗарегистрированныеДисконтныеКарты = Новый Массив;
	
	Если ТипЗнч(Данные) = Тип("Массив") Тогда
		// Расшифруем данные дорожки по тем шаблонам, которые используются в видах дисконтных карт.
		РасшифрованныеДанные = РасшифроватьКодМагнитнойКарты(Данные[1][1]);
		Данные[1][3] = РасшифрованныеДанные;
		
		Если РасшифрованныеДанные <> Неопределено Тогда
			Для Каждого Структура Из РасшифрованныеДанные Цикл
				
				ШаблонДисконтнойКарты = Структура.Шаблон;
				КодКарты             = Данные[0];
				Для Каждого ДанныеПоля Из Структура.ДанныеДорожек Цикл
					Если ДанныеПоля.Поле = Перечисления.ПоляШаблоновМагнитныхКарт.Код Тогда
						КодКарты = ДанныеПоля.ЗначениеПоля;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Запрос = Новый Запрос(
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ВидыДисконтныхКарт.Ссылка КАК Ссылка,
				|	ВидыДисконтныхКарт.ЭтоИменнаяКарта КАК ЭтоИменнаяКарта,
				|	ВидыДисконтныхКарт.ТипКарты КАК ТипКарты
				|ПОМЕСТИТЬ ВидыКарт
				|ИЗ
				|	Справочник.ВидыДисконтныхКарт КАК ВидыДисконтныхКарт
				|ГДЕ
				|	(ВидыДисконтныхКарт.ТипКарты = &ТипКартыСмешанная
				|			ИЛИ ВидыДисконтныхКарт.ТипКарты = &ТипКарты)
				|	И ВидыДисконтныхКарт.ШаблонДисконтнойКарты = &ШаблонДисконтнойКарты
				|	И НЕ ВидыДисконтныхКарт.ПометкаУдаления
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ДисконтныеКарты.Ссылка КАК Ссылка,
				|	ДисконтныеКарты.Наименование КАК Наименование,
				|	ДисконтныеКарты.КодКартыШтрихкод КАК Штрихкод,
				|	ДисконтныеКарты.КодКартыМагнитный КАК МагнитныйКод,
				|	ДисконтныеКарты.ВладелецКарты КАК Контрагент,
				|	ДисконтныеКарты.Владелец КАК ВидКарты,
				|	ДисконтныеКарты.Владелец.ЭтоИменнаяКарта КАК ЭтоИменнаяКарта,
				|	ДисконтныеКарты.Владелец.ТипКарты КАК ТипКарты
				|ПОМЕСТИТЬ ДисконтныеКарты
				|ИЗ
				|	Справочник.ДисконтныеКарты КАК ДисконтныеКарты
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВидыКарт КАК ВидыКарт
				|		ПО (ВидыКарт.Ссылка = ДисконтныеКарты.Владелец)
				|			И (ДисконтныеКарты.КодКартыМагнитный = &КодКарты)
				|			И (НЕ ДисконтныеКарты.ПометкаУдаления)
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	1 КАК Порядок,
				|	ДисконтныеКарты.Ссылка КАК Ссылка,
				|	ДисконтныеКарты.Наименование КАК Наименование,
				|	ДисконтныеКарты.Штрихкод КАК Штрихкод,
				|	ДисконтныеКарты.МагнитныйКод КАК МагнитныйКод,
				|	ДисконтныеКарты.Контрагент КАК Контрагент,
				|	ДисконтныеКарты.ВидКарты КАК ВидКарты,
				|	ДисконтныеКарты.ЭтоИменнаяКарта КАК ЭтоИменнаяКарта,
				|	ДисконтныеКарты.ТипКарты КАК ТипКарты
				|ИЗ
				|	ДисконтныеКарты КАК ДисконтныеКарты
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ
				|	2,
				|	ЗНАЧЕНИЕ(Справочник.ДисконтныеКарты.ПустаяСсылка),
				|	"""",
				|	"""",
				|	&КодКарты,
				|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),
				|	ВидыКарт.Ссылка,
				|	ВидыКарт.ЭтоИменнаяКарта,
				|	ВидыКарт.ТипКарты
				|ИЗ
				|	ВидыКарт КАК ВидыКарт
				|ГДЕ
				|	НЕ ВидыКарт.Ссылка В
				|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
				|					Т.ВидКарты
				|				ИЗ
				|					ДисконтныеКарты КАК Т)
				|
				|УПОРЯДОЧИТЬ ПО
				|	Порядок");
				
				Запрос.УстановитьПараметр("ТипКартыСмешанная", Перечисления.ТипыКарт.Смешанная);
				Если ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод Тогда
					Запрос.УстановитьПараметр("ТипКарты", Перечисления.ТипыКарт.Магнитная);
				Иначе
					Запрос.УстановитьПараметр("ТипКарты", Перечисления.ТипыКарт.Штриховая);
				КонецЕсли;
				
				Запрос.УстановитьПараметр("ШаблонДисконтнойКарты", ШаблонДисконтнойКарты);
				Запрос.УстановитьПараметр("КодКарты",             КодКарты);
				Запрос.УстановитьПараметр("ДлинаКода",            СтрДлина(КодКарты));
				
				Результат = Запрос.Выполнить();
				Выборка = Результат.Выбрать();
				Пока Выборка.Следующий() Цикл
				
					Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
						НоваяСтрока = ДисконтныеКартыСервер.ПолучитьСтруктуруДанныхДисконтнойКарты();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
						ЗарегистрированныеДисконтныеКарты.Добавить(НоваяСтрока);
					Иначе
						НоваяСтрока = ДисконтныеКартыСервер.ПолучитьСтруктуруДанныхДисконтнойКарты();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
						НеЗарегистрированныеДисконтныеКарты.Добавить(НоваяСтрока);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
			ВозвращаемоеЗначение = Новый Структура("ЗарегистрированныеДисконтныеКарты, НеЗарегистрированныеДисконтныеКарты");
			ВозвращаемоеЗначение.ЗарегистрированныеДисконтныеКарты   = ЗарегистрированныеДисконтныеКарты;
			ВозвращаемоеЗначение.НеЗарегистрированныеДисконтныеКарты = НеЗарегистрированныеДисконтныеКарты;
		Иначе
			КодКарты = Данные[0];
			ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты);
			ВозвращаемоеЗначение = ДисконтныеКартыСервер.НайтиДисконтныеКартыПоМагнитномуКоду(КодКарты);
		КонецЕсли;
	Иначе
		КодКарты = Данные;
		ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты);
		ВозвращаемоеЗначение = ДисконтныеКартыСервер.НайтиДисконтныеКартыПоМагнитномуКоду(КодКарты);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Функция выполняет поиск дисконтных карт по данным, полученным из считывателя
// магнитных карт
//
// Параметры
//  Данные - Массив данных, полученный из считывателя магнитных карт.
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные дисконтные карты
//  и НеЗарегистрированныеДисконтныеКарты.
//
Функция НайтиВидыДисконтныхКартПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода, ВидДисконтнойКарты) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗарегистрированныеДисконтныеКарты = Новый Массив;
	НеЗарегистрированныеДисконтныеКарты = Новый Массив;
	
	Если ТипЗнч(Данные) = Тип("Массив") Тогда
		ЕстьШаблон = Ложь;
		Если ЗначениеЗаполнено(ВидДисконтнойКарты) Тогда
			Если ЗначениеЗаполнено(ВидДисконтнойКарты.ШаблонДисконтнойКарты) Тогда
				ЕстьШаблон = Истина;
				ТекШаблон = ВидДисконтнойКарты.ШаблонДисконтнойКарты;
			Иначе
				КодКарты = Данные[0];
				ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты);
				ВозвращаемоеЗначение = Новый СписокЗначений;
				ВозвращаемоеЗначение.Добавить(КодКарты, КодКарты);
				
				Возврат ВозвращаемоеЗначение;
			КонецЕсли;
		КонецЕсли;
		
		// Расшифруем данные дорожки по тем шаблонам, которые используются в видах дисконтных карт.
		РасшифрованныеДанные = РасшифроватьКодМагнитнойКарты(Данные[1][1]);
		
		Если РасшифрованныеДанные <> Неопределено Тогда
			ВозвращаемоеЗначение = Новый СписокЗначений;
			
			Для каждого ТекДанныеПоШаблону Из РасшифрованныеДанные Цикл
			
				Для Каждого ДанныеДорожки Из ТекДанныеПоШаблону.ДанныеДорожек Цикл
					Если ДанныеДорожки.Поле = Перечисления.ПоляШаблоновМагнитныхКарт.Код Тогда
						Если ЕстьШаблон И ТекДанныеПоШаблону.Шаблон = ТекШаблон Тогда
							ВозвращаемоеЗначение.Добавить(ДанныеДорожки.ЗначениеПоля, ""+ДанныеДорожки.ЗначениеПоля+" ("+ТекДанныеПоШаблону.Шаблон+")");
							Возврат ВозвращаемоеЗначение;
						ИначеЕсли Не ЕстьШаблон Тогда
							ВозвращаемоеЗначение.Добавить(ДанныеДорожки.ЗначениеПоля, ""+ДанныеДорожки.ЗначениеПоля+" ("+ТекДанныеПоШаблону.Шаблон+")");
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;				
			
			КонецЦикла;
		ИначеЕсли Не ЕстьШаблон Тогда
			КодКарты = Данные[0];
			ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты);
			ВозвращаемоеЗначение = Новый СписокЗначений;
			ВозвращаемоеЗначение.Добавить(КодКарты, КодКарты);
		Иначе
			Возврат Новый СписокЗначений;
		КонецЕсли;
	Иначе
		КодКарты = Данные;
		ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты);
		ВозвращаемоеЗначение = Новый СписокЗначений;
		ВозвращаемоеЗначение.Добавить(ВидДисконтнойКарты, КодКарты);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Процедура убирает слева знак ";" и справа знак "?"
//
Процедура ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты) Экспорт
	
	// Во многих случаях данные на магнитную карту записываются только на вторую дорожку.
	// Данные на второй дорожке содержат номер, который заключон между префиксом и суфиксом. 
	// Чаще всего это символы ";" и "?". Например, ";00001234?".
	// В некоторых случаях на 2-ой дорожке записывают несколько блоков, которые разделяют с помощью специального символа-разделителя.
	// Чаще всего это символ "=". Например, ";1234505718812345=1239721320000000?".
	// Удалим префикс и суффикс. Оставим данные только 1-го блока.
	// В более сложных случаях требуется использовать справочник "ШаблоныМагнитныхКарт".
	КодКарты = СокрЛП(КодКарты);
	Если Лев(КодКарты, 1) = ";" Тогда
		КодКарты = Сред(КодКарты, 2);
	КонецЕсли;
	Если Прав(КодКарты, 1) = "?" Тогда
		КодКарты = Лев(КодКарты, СтрДлина(КодКарты) - 1);
	КонецЕсли;
	
	ПозицияРазделителя = СтрНайти(КодКарты, "=");	
	Если ПозицияРазделителя = 1 Тогда // Например, ";=1239721320000000?".
		КодКарты = Прав(КодКарты, СтрДлина(КодКарты)-1);
	ИначеЕсли ПозицияРазделителя > 1 Тогда
		КодКарты = Лев(КодКарты, ПозицияРазделителя-1);		
	КонецЕсли;
	
КонецПроцедуры

// Функция выполняет поиск дисконтных карт по штрихкоду
//
// Параметры
//  Штрихкод - Строка
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные дисконтные карты
//  и НеЗарегистрированныеДисконтныеКарты.
//
Функция НайтиДисконтныеКартыПоШтрихкоду(Штрихкод) Экспорт
	
	Возврат ДисконтныеКартыСервер.НайтиДисконтныеКарты(Штрихкод, Перечисления.ТипыКодовКарт.Штрихкод);
	
КонецФункции

// Производит разложение данных дорожек магнитной карты по шаблонам
// На входе:
// ДанныеДорожек - массив строк. Значения полученные из дорожек.
// ПараметрыДорожек - массив структур содержащих параметры настройки устройства
//  * Использовать, булево - признак использования дорожки
//  * НомерДорожки, число - порядковый номер дорожки 1-3
//
// На выходе:
// Массив структур содержащих расшифрованные данные по всем подходящим шаблонам со ссылкой на них
// * Массив - шаблоны
//   * Структура - данные шаблона
//     - Шаблон, СправочникСсылка.ШаблоныМагнитныхКарт
//     - ДанныеДорожек, массив полей всех дорожек
//       * Структура - данные поля
//         - Поле
//         - ЗначениеПоля
Функция РасшифроватьКодМагнитнойКарты(ДанныеДорожек) Экспорт
	
	Если ДанныеДорожек.Количество() = 0 Тогда
		Возврат Неопределено; // нет данных
	КонецЕсли;
	
	// Проверяем только данные 2-ой дорожки.
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ШаблоныДисконтныхКарт.Ссылка,
	|	ШаблоныДисконтныхКарт.Префикс,
	|	ШаблоныДисконтныхКарт.Суффикс,
	|	ШаблоныДисконтныхКарт.ДлинаКода,
	|	ШаблоныДисконтныхКарт.РазделительБлоков,
	|	ШаблоныДисконтныхКарт.ДлинаПоля,
	|	ВЫБОР
	|		КОГДА ШаблоныДисконтныхКарт.НомерБлока = 0
	|			ТОГДА 1
	|		ИНАЧЕ ШаблоныДисконтныхКарт.НомерБлока
	|	КОНЕЦ КАК НомерБлока,
	|	ШаблоныДисконтныхКарт.БезОграниченияРазмера,
	|	ШаблоныДисконтныхКарт.НомерПервогоСимволаПоля
	|ИЗ
	|	Справочник.ШаблоныДисконтныхКарт КАК ШаблоныДисконтныхКарт
	|ГДЕ
	|	(ШаблоныДисконтныхКарт.ДлинаКода = &ДлинаКода
	|			ИЛИ ШаблоныДисконтныхКарт.БезОграниченияРазмера)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Справочник.ШаблоныДисконтныхКарт.ПустаяСсылка),
	|	"";"",
	|	""?"",
	|	0,
	|	"""",
	|	0,
	|	1,
	|	ИСТИНА,
	|	0");
	Запрос.УстановитьПараметр("ДлинаКода", СтрДлина(СокрЛП(ДанныеДорожек[1])));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СписокШаблонов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		
		// 2-ой этап - Пропускаем шаблоны не совпадающие по суффиксу, префиксу, разделителю.
		
		Если НЕ КодСоответствуетШаблонуМК(ДанныеДорожек, Выборка) Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеДорожки = Новый Массив;
		
		// Поиск блока по номеру
		ДанныеСтрока = ДанныеДорожек[1]; // Обрабатываем данные только из 2-ой дорожки.
		Префикс = Выборка["Префикс"];
		Если Префикс = Лев(ДанныеСтрока, СтрДлина(Префикс)) Тогда
			ДанныеСтрока = Прав(ДанныеСтрока, СтрДлина(ДанныеСтрока)-СтрДлина(Префикс)); // Удаляем префикс если есть
		КонецЕсли;
		Суффикс = Выборка["Суффикс"];
		Если Суффикс = Прав(ДанныеСтрока, СтрДлина(Суффикс)) Тогда
			ДанныеСтрока = Лев(ДанныеСтрока, СтрДлина(ДанныеСтрока)-СтрДлина(Суффикс)); // Удаляем суффикс если есть
		КонецЕсли;
		
		текНомерБлока = 0;
		Пока текНомерБлока < Выборка.НомерБлока Цикл
			РазделительБлоков = Выборка["РазделительБлоков"];
			ПозицияРазделителя = СтрНайти(ДанныеСтрока, РазделительБлоков);
			Если ПустаяСтрока(РазделительБлоков) ИЛИ ПозицияРазделителя = 0 Тогда
				Блок = ДанныеСтрока;
			ИначеЕсли ПозицияРазделителя = 1 Тогда
				Блок = "";
				ДанныеСтрока = Прав(ДанныеСтрока, СтрДлина(ДанныеСтрока)-1);
			Иначе
				Блок = Лев(ДанныеСтрока, ПозицияРазделителя-1);
				ДанныеСтрока = Прав(ДанныеСтрока, СтрДлина(ДанныеСтрока)-ПозицияРазделителя);
			КонецЕсли;
			текНомерБлока = текНомерБлока + 1;
		КонецЦикла;
		
		// Поиск подстроки в блоке
		ЗначениеПоля = Сред(Блок, Выборка.НомерПервогоСимволаПоля, ?(Выборка.ДлинаПоля = 0, СтрДлина(Блок), Выборка.ДлинаПоля));
		
		ДанныеПоля = Новый Структура("Поле, ЗначениеПоля", Перечисления.ПоляШаблоновМагнитныхКарт.Код, ЗначениеПоля);
		ДанныеДорожки.Добавить(ДанныеПоля);
		
		Шаблон = Новый Структура("Шаблон, ДанныеДорожек", Выборка.Ссылка, ДанныеДорожки);
		СписокШаблонов.Добавить(Шаблон);
	КонецЦикла;
	
	Если СписокШаблонов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СписокШаблонов;
	
КонецФункции

// Определяет соответствует ли код карты шаблону
// На входе:
// ДанныеДорожек - Массив содержащий строки кода дорожки. Всего 3 Элемента.
// ДанныеШаблона - структура содержащая данные шаблона:
//	- Суффикс
//	- Префикс
//	- РазделительБлоков
//	- ДлинаКода
// На выходе:
// Истина - код соответствует шаблону
Функция КодСоответствуетШаблонуМК(ДанныеДорожек, ДанныеШаблона)
	// Проверяем только 2-ую дорожку.
	текСтрока = ДанныеДорожек[1];
	Если Прав(текСтрока, СтрДлина(ДанныеШаблона["Суффикс"])) <> ДанныеШаблона["Суффикс"]
		ИЛИ Лев(текСтрока, СтрДлина(ДанныеШаблона["Префикс"])) <> ДанныеШаблона["Префикс"]
		ИЛИ СтрНайти(текСтрока, ДанныеШаблона["РазделительБлоков"]) = 0
		ИЛИ (СтрДлина(текСтрока) <> ДанныеШаблона["ДлинаКода"] И НЕ ДанныеШаблона["БезОграниченияРазмера"]) Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

#КонецОбласти

Функция НужноОчиститьДисконтнуюКартуПриСменеВладельца(пКонтрагент, пДисконтнаяКарта, пПустойКонтрагентПередИзменением) Экспорт
	
	// Если ДК именная и поменялся владелец, то затираем ДК.
	// Если ДК не именная и контрагент поменялся с пустого значения на непустое, то не затираем.
	ВладелецКарты = УправлениеНебольшойФирмойВызовСервера.ЗначениеРеквизитаОбъекта(пДисконтнаяКарта, "ВладелецКарты");
	Очистить = (ЗначениеЗаполнено(ВладелецКарты) И ВладелецКарты <> пКонтрагент)
		Или Не пПустойКонтрагентПередИзменением;
	Возврат Очистить;
	
КонецФункции

// Старый механизм скидок
//
// Параметры:
//  ДисконтнаяКарта - СправочникСсылка.ДисконтныеКарты
// 
// Возвращаемое значение:
//  Булево - используется старый механизм скидок
//
Функция СтарыйМеханизмСкидок(ДисконтнаяКарта) Экспорт
	
	Возврат ДисконтнаяКарта.Владелец.СтарыйМеханизмСкидок;
	
КонецФункции

#КонецОбласти
