
#Область СлужебныеПроцедурыИФункции

#Область КонстантныеЗначения

Функция СтрокаКонцаОперанда() Экспорт
	
	Возврат "]";
	
КонецФункции

Функция СтрокаНачалаОперанда() Экспорт
	
	Возврат "[";
	
КонецФункции

Функция МассивЗарезирвированныхСлов()
	
	МассивЗарезирвированныхОперандов = Новый Массив;
	
	МассивЗарезирвированныхОперандов.Добавить("ТекущееЗначение");
	МассивЗарезирвированныхОперандов.Добавить("ПоследняяЦенаВПриходе");
	МассивЗарезирвированныхОперандов.Добавить("ПоследняяЦенаВРасходе");
	МассивЗарезирвированныхОперандов.Добавить("КурсДоллара");
	МассивЗарезирвированныхОперандов.Добавить("КурсЕвро");
	МассивЗарезирвированныхОперандов.Добавить("Себестоимость");
	МассивЗарезирвированныхОперандов.Добавить("СебестоимостьНацВалюта");
	
	Возврат МассивЗарезирвированныхОперандов;
	
КонецФункции

Функция ЭтоЗарезервированныйОперанд(Операнд)
	
	ЗарезервированныеСлова = МассивЗарезирвированныхСлов();
	
	Идентификатор = СтрЗаменить(Операнд, СтрокаНачалаОперанда(), "");
	Идентификатор = СтрЗаменить(Идентификатор, СтрокаКонцаОперанда(), "");
	
	ЭлементМассива = ЗарезервированныеСлова.Найти(Идентификатор);
	
	Возврат (ЭлементМассива <> Неопределено);
	
КонецФункции

#КонецОбласти

#Область Формулы

Процедура ПарсингФормулыНаОперанды(ПериодЗаписи, Формула, Операнды)
	
	ТекстФормулы = СокрЛП(Формула);
	Если ПустаяСтрока(Формула) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СимволНачалоОперанда= СтрокаНачалаОперанда();
	СимволКонецОперанда	= СтрокаКонцаОперанда();
	
	КоличествоОперандов = СтрЧислоВхождений(ТекстФормулы, СимволНачалоОперанда);
	Пока КоличествоОперандов > 0 Цикл
		
		НачалоОперанда	= Найти(ТекстФормулы, СимволНачалоОперанда);
		КонецОперанда	= Найти(ТекстФормулы, СимволКонецОперанда);
		
		Операнд 		= Сред(ТекстФормулы, НачалоОперанда, КонецОперанда - НачалоОперанда + 1);
		Идентификатор	= СтрЗаменить(СтрЗаменить(Операнд, СимволНачалоОперанда, ""), СимволКонецОперанда, "");
		Результат		= НайтиВидЦенПоИдентификатору(Идентификатор);
		
		Если Операнды.Найти(Операнд, "Операнд") <> Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		НовыйОперанд = Операнды.Добавить();
		НовыйОперанд.Операнд			= Операнд;
		НовыйОперанд.ВидЦен				= Результат.ВидЦен;
		НовыйОперанд.ЭтоЦеныНоменклатуры= Результат.ЭтоЦеныНоменклатуры;
		
		Если НовыйОперанд.ЭтоЦеныНоменклатуры <> Неопределено Тогда
			
			ВалютаВидаЦен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НовыйОперанд.ВидЦен, "ВалютаЦены");
			Если ЗначениеЗаполнено(ВалютаВидаЦен) Тогда
				
				ДанныеКурсаВалютыВидаЦен = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВидаЦен, ПериодЗаписи);
				
				НовыйОперанд.ВидЦенКурс = ДанныеКурсаВалютыВидаЦен.Курс;
				НовыйОперанд.ВидЦенКратность = ДанныеКурсаВалютыВидаЦен.Кратность;
				
			Иначе
				
				НовыйОперанд.ВидЦенКурс = 1;
				НовыйОперанд.ВидЦенКратность = 1;
				
			КонецЕсли;
			
		КонецЕсли;
		
		КоличествоОперандов = КоличествоОперандов - СтрЧислоВхождений(ТекстФормулы, Операнд);
		ТекстФормулы 		= СтрЗаменить(ТекстФормулы, Операнд, "");
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТаблицуОперандовФормулы(ПериодЗаписи, ХранилищеФормул) Экспорт
	
	Операнды = Новый ТаблицаЗначений;
	Операнды.Колонки.Добавить("Операнд");
	Операнды.Колонки.Добавить("ВидЦен");
	Операнды.Колонки.Добавить("ВидЦенКурс");
	Операнды.Колонки.Добавить("ВидЦенКратность");
	Операнды.Колонки.Добавить("ЭтоЦеныНоменклатуры");
	
	Операнды.Индексы.Добавить("Операнд");
	
	Если ТипЗнч(ХранилищеФормул) = Тип("Строка") Тогда
		
		ПарсингФормулыНаОперанды(ПериодЗаписи, ХранилищеФормул, Операнды);
		
	ИначеЕсли ТипЗнч(ХранилищеФормул) = Тип("Массив") Тогда
		
		Для каждого ЭлементМассива Из ХранилищеФормул Цикл
			
			ПарсингФормулыНаОперанды(ПериодЗаписи, ЭлементМассива, Операнды);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Операнды;
	
КонецФункции

Функция НайтиВидЦенПоИдентификатору(Идентификатор, ИсключаяСсылку = Неопределено) Экспорт
	
	Результат = Новый Структура("ИдентификаторЗанят, ВидЦен, ЭтоЦеныНоменклатуры", Ложь, Неопределено, Неопределено);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ Справочник.ВидыЦен.Ссылка КАК ВидЦен, ИСТИНА КАК ЭтоЦеныНоменклатуры ГДЕ Справочник.ВидыЦен.ИдентификаторФормул = &Идентификатор
	|ОБЪЕДИНИТЬ ВСЕ 
	|ВЫБРАТЬ Справочник.ВидыЦенКонтрагентов.Ссылка, ЛОЖЬ ГДЕ Справочник.ВидыЦенКонтрагентов.ИдентификаторФормул = &Идентификатор");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ИсключаяСсылку = Выборка.ВидЦен Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Результат.ИдентификаторЗанят	= Истина;
		Результат.ВидЦен 				= Выборка.ВидЦен;
		Результат.ЭтоЦеныНоменклатуры	= Выборка.ЭтоЦеныНоменклатуры;
		
	КонецЦикла;
	
	Если НЕ Результат.ИдентификаторЗанят Тогда
	
		ЗарезервированныеСлова = МассивЗарезирвированныхСлов();
		
		ЭлементМассива = ЗарезервированныеСлова.Найти(Идентификатор);
		
		Если ЭлементМассива <> Неопределено Тогда
			
			Результат.ИдентификаторЗанят	= Истина;
			Результат.ВидЦен 				= Неопределено;
			Результат.ЭтоЦеныНоменклатуры	= Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОкруглитьЧислоПоПравилу(Число, ОкруглятьВБольшуюСторону, ПравилоОкругления) Экспорт
	Перем Результат; // Возвращаемый результат.
	
	Если НЕ ЗначениеЗаполнено(Число) Тогда
		
		Возврат 0;
		
	КонецЕсли;
	
	Если ОкруглятьВБольшуюСторону <> Истина
		И ОкруглятьВБольшуюСторону <> Ложь Тогда
		
		ОкруглятьВБольшуюСторону = Ложь;
		
	КонецЕсли;
	
	ПорядокОкругления0_01 = Перечисления.ПорядкиОкругления.Окр0_01;
	
	// Преобразуем порядок округления числа.
	// Если передали пустое значение порядка, то округлим до копеек. 
	ПорядокОкругления	= ?(ЗначениеЗаполнено(ПравилоОкругления), ПравилоОкругления, ПорядокОкругления0_01);
	Порядок 			= Число(Строка(ПорядокОкругления));
	
	// вычислим количество интервалов, входящих в число
	КоличествоИнтервал	= Число / Порядок;
	
	// вычислим целое количество интервалов.
	КоличествоЦелыхИнтервалов = Цел(КоличествоИнтервал);
	
	Если КоличествоИнтервал = КоличествоЦелыхИнтервалов Тогда
		
		// Числа поделились нацело. Округлять не нужно.
		Результат	= Число;
	Иначе
		Если ОкруглятьВБольшуюСторону = Истина Тогда
			
			// При порядке округления "0.05" 0.371 должно округлиться до 0.4
			Результат = Порядок * (КоличествоЦелыхИнтервалов + 1);
		Иначе
			
			// При порядке округления "0.05" 0.371 должно округлиться до 0.35,
			// а 0.376 до 0.4
			Результат = Порядок * Окр(КоличествоИнтервал, 0, РежимОкругления.Окр15как20);
		КонецЕсли; 
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ОкруглитьЦенуПоПравилам()

Процедура СформироватьНовыйИдентификаторВидаЦен(Идентификатор, ВидЦенНаименование, ВидЦенВладелец = "") Экспорт
	
	Если ПустаяСтрока(ВидЦенНаименование) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Идентификатор = Строка(ВидЦенВладелец) + Строка(ВидЦенНаименование);
	
	ДлинаСтроки = СтрДлина(Идентификатор);
	Пока ДлинаСтроки > 0 Цикл
		
		КодСимвола = КодСимвола(Идентификатор, ДлинаСтроки);
		
		Если НЕ ((КодСимвола >= 48 И КодСимвола <= 57) // Числа 
			ИЛИ (КодСимвола >= 65 И КодСимвола <= 90) // Лат. заглавные
			ИЛИ (КодСимвола >= 97 И КодСимвола <= 122) // Лат. прописные
			ИЛИ (КодСимвола >= 1040 И КодСимвола <= 1103)) // Кирилица
			Тогда
			
			Идентификатор = Сред(Идентификатор, 1, ДлинаСтроки - 1) + Сред(Идентификатор, ДлинаСтроки + 1);
			
		КонецЕсли;
		
		ДлинаСтроки = ДлинаСтроки - 1;
		
	КонецЦикла;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		
		Идентификатор = НСтр("ru ='ИдентификаторВидаЦен'");
		
	КонецЕсли;
	
	// первым символом должна быть буква
	КодСимвола = КодСимвола(Идентификатор, 1);
	Если КодСимвола >= 48 И КодСимвола <= 57 Тогда
		
		Идентификатор = "a" + Идентификатор;
		
	КонецЕсли;
	
	Постфикс = 0;
	ИдентификаторТело = Идентификатор;
	Пока НайтиВидЦенПоИдентификатору(Идентификатор).ИдентификаторЗанят Цикл
		
		Постфикс = Постфикс + 1;
		Идентификатор = ИдентификаторТело + Строка(Постфикс);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьВидЦенНаИспользованиеВФормулах(Знач ВидЦен) Экспорт
	Перем ОписаниеИспользования;
	
	Если ТипЗнч(ВидЦен) = Тип("Строка") Тогда
		
		Результат	= НайтиВидЦенПоИдентификатору(ВидЦен);
		ВидЦен 		= Результат.ВидЦен;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
		
		Возврат ОписаниеИспользования;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидЦенБазовый", ВидЦен);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СвязьВЦ.ВидЦенРасчетный КАК Ссылка,
	|	СвязьВЦ.ВидЦенРасчетный.Наименование КАК Наименование
	|ИЗ
	|	РегистрСведений.СвязиВидовЦенСлужебный КАК СвязьВЦ
	|ГДЕ
	|	СвязьВЦ.ВидЦенРасчетный.ТипВидаЦен = Значение(Перечисление.ТипыВидовЦен.ДинамическийФормула)
	|	И (СвязьВЦ.ВидЦенБазовый = &ВидЦенБазовый
	|			ИЛИ СвязьВЦ.ВидЦенБазовыйЦеновойГруппы = &ВидЦенБазовый)";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат ОписаниеИспользования;
		
	КонецЕсли;
	
	ОписаниеИспользования = Новый Массив;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОписаниеИспользования.Добавить(Новый Структура("Ссылка, Наименование", Выборка.Ссылка, Выборка.Наименование));
		
	КонецЦикла;
	
	Возврат ОписаниеИспользования;
	
КонецФункции

Процедура ПроверитьФормулу(Ошибки, Формула) Экспорт
	Перем СоответствиеОперандов, РасчетныеДанные;
	
	ЗначениеВсехОперандов = 10; // При проверке формулы значения всех операндов принимаем равным 10
	
	ТекстФормулы = СокрЛП(Формула);
	Если СтрЧислоВхождений(ТекстФормулы, СтрокаНачалаОперанда()) <> СтрЧислоВхождений(ТекстФормулы, СтрокаКонцаОперанда()) Тогда
		
		ТекстОшибки = НСтр("ru ='Количество открытых операндов не равно количеству закрытых.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Формула", ТекстОшибки, "");
		
	КонецЕсли;
	
	Если СтрЧислоВхождений(ТекстФормулы, "(") <> СтрЧислоВхождений(ТекстФормулы, ")") Тогда
		
		ТекстОшибки = НСтр("ru ='Количество открытых скобок не равно количеству закрытых.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Формула", ТекстОшибки, "");
		
	КонецЕсли;
	
	ТаблицаОперандов = ПолучитьТаблицуОперандовФормулы(ТекущаяДатаСеанса(), Формула);
	Для каждого Строка Из ТаблицаОперандов Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.ВидЦен) Тогда
			
			Если НЕ ЭтоЗарезервированныйОперанд(Строка.Операнд) Тогда
			
				ТекстОшибки = НСтр("ru ='Не распознан операнд %1.
										|Проверьте правильность написания формулы.'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Строка.Операнд);
				
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Формула", ТекстОшибки, "");
				
			КонецЕсли;
			
		КонецЕсли;
		
		ДобавитьОперандВСтруктуру(СоответствиеОперандов, Строка.Операнд, ЗначениеВсехОперандов);
		
	КонецЦикла;
	
	РасчетДанныхПоФормуле(ТекстФормулы, СоответствиеОперандов, РасчетныеДанные);
		
	Если РасчетныеДанные.ОшибкаРасчета Тогда
		
		ТекстОшибки = НСтр("ru ='При расчете возникли ошибки. Проверьте правильность написания формулы.
			|Подробное описание: '") + Символы.ПС + РасчетныеДанные.ТекстОшибки;
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Формула", ТекстОшибки, "");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьОперандВСтруктуру(СоответствиеОперандов, Операнд, Значение) Экспорт
	
	Если ТипЗнч(СоответствиеОперандов) <> Тип("Соответствие") Тогда
		
		СоответствиеОперандов = Новый Соответствие;
		
	КонецЕсли;
	
	СоответствиеОперандов.Вставить(Операнд, Значение);
	
КонецПроцедуры

Процедура РасчетДанныхПоФормуле(Знач ФормулаСтрокой, СтруктураОперандов, РасчетныеДанные, ОкруглятьВБольшуюСторону = Неопределено, ПравилоОкругления = Неопределено)
	
	Если РасчетныеДанные = Неопределено Тогда
		
		РасчетныеДанные = Новый Структура("Цена, Курс, Кратность, ЕдиницаИзмерения, ОшибкаРасчета, ТекстОшибки", 0, 1, 1, Неопределено, Ложь)
		
	КонецЕсли;
	
	Если СтруктураОперандов = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Найти(ФормулаСтрокой, "#ЕСЛИ") > 0 Тогда
		
		ФормулаСтрокой = СтрЗаменить(ФормулаСтрокой, "#ЕСЛИ",		"?(");
		ФормулаСтрокой = СтрЗаменить(ФормулаСтрокой, "#ТОГДА",		",");
		ФормулаСтрокой = СтрЗаменить(ФормулаСтрокой, "#ИНАЧЕ",		",");
		ФормулаСтрокой = СтрЗаменить(ФормулаСтрокой, "#КОНЕЦЕСЛИ",	")");
		ФормулаСтрокой = СтрЗаменить(ФормулаСтрокой, Символы.ПС,	"");
		
	КонецЕсли;
	
	Для каждого Операнд Из СтруктураОперандов Цикл
		
		ФормулаСтрокой = СтрЗаменить(ФормулаСтрокой, Операнд.Ключ, Операнд.Значение);
		
	КонецЦикла;
	
	Попытка
		
		РассчитанаяЦена = ОбщегоНазначения.ВычислитьВБезопасномРежиме(ФормулаСтрокой);
		
		Если ЗначениеЗаполнено(РассчитанаяЦена)
			И ЗначениеЗаполнено(ОкруглятьВБольшуюСторону)
			И ЗначениеЗаполнено(ПравилоОкругления) Тогда
			
			РасчетныеДанные.Цена = ОкруглитьЧислоПоПравилу(РассчитанаяЦена, ОкруглятьВБольшуюСторону, ПравилоОкругления);
			
		Иначе
			
			РасчетныеДанные.Цена = 0;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(РасчетныеДанные.ЕдиницаИзмерения) Тогда
			
			РасчетнаяЕдиницаИзмерения = Неопределено;
			Для каждого Операнд Из СтруктураОперандов Цикл
				
				Если Найти(Операнд.Ключ, "ЕдиницаИзмерения") > 0 Тогда
					
					РасчетнаяЕдиницаИзмерения = Операнд.Значение;
					Если ТипЗнч(РасчетнаяЕдиницаИзмерения) = Тип("СправочникСсылка.КлассификаторЕдиницИзмерения") Тогда
						
						Прервать;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
			РасчетныеДанные.ЕдиницаИзмерения = РасчетнаяЕдиницаИзмерения;
			
		КонецЕсли;
		
	Исключение
		
		РасчетныеДанные.ОшибкаРасчета	= Истина;
		РасчетныеДанные.ТекстОшибки		= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ПодготовитьДанныеСтрокиКоллекции(СоответствиеОперандов, СтрокаКоллекции, ТаблицаОперандов, РасчетныеДанные)
	
	Для каждого СтрокаОперанда Из ТаблицаОперандов Цикл
		
		Значение				= 0;
		ЗначениеКурс			= 1;
		ЗначениеКратность		= 1;
		ЗначениеНовыйКурс		= 1;
		ЗначениеНоваяКратность	= 1;
		
		Если СтрокаОперанда.ЭтоЦеныНоменклатуры <> Неопределено Тогда
			
			ИдентификаторФормул = СтрокаОперанда.ВидЦен.ИдентификаторФормул;
			
			Значение 				= СтрокаКоллекции["Значение_" + ИдентификаторФормул];
			ЗначениеКурс 			= СтрокаКоллекции["Курс_" + ИдентификаторФормул];
			ЗначениеКратность		= СтрокаКоллекции["Кратность_" + ИдентификаторФормул];
			ЗначениеНовыйКурс		= РасчетныеДанные.Курс;
			ЗначениеНоваяКратность	= РасчетныеДанные.Кратность;
			
			КлючЕдиницыИзмерения = "ЕдиницаИзмерения_" + СтрокаОперанда.ВидЦен.ИдентификаторФормул;
			ЕдиницаИзмерения	= СтрокаКоллекции[КлючЕдиницыИзмерения];
			
		ИначеЕсли СтрокаОперанда.Операнд = "[ПоследняяЦенаВПриходе]" Тогда
			
			Значение 				= СтрокаКоллекции["Значение_ПоследняяЦенаВПриходе"];
			ЗначениеКурс 			= СтрокаКоллекции["Курс_ПоследняяЦенаВПриходе"];
			ЗначениеКратность		= СтрокаКоллекции["Кратность_ПоследняяЦенаВПриходе"];
			ЗначениеНовыйКурс		= РасчетныеДанные.Курс;
			ЗначениеНоваяКратность	= РасчетныеДанные.Кратность;
			
			КлючЕдиницыИзмерения = "ЕдиницаИзмерения_ПоследняяЦенаВПриходе";
			ЕдиницаИзмерения	= СтрокаКоллекции["ЕдиницаИзмерения_ПоследняяЦенаВПриходе"];
			
		ИначеЕсли СтрокаОперанда.Операнд = "[ПоследняяЦенаВРасходе]" Тогда
			
			Значение 				= СтрокаКоллекции["Значение_ПоследняяЦенаВРасходе"];
			ЗначениеКурс 			= СтрокаКоллекции["Курс_ПоследняяЦенаВРасходе"];
			ЗначениеКратность		= СтрокаКоллекции["Кратность_ПоследняяЦенаВРасходе"];
			ЗначениеНовыйКурс		= РасчетныеДанные.Курс;
			ЗначениеНоваяКратность	= РасчетныеДанные.Кратность;
			
			КлючЕдиницыИзмерения = "ЕдиницаИзмерения_ПоследняяЦенаВРасходе";
			ЕдиницаИзмерения	= СтрокаКоллекции["ЕдиницаИзмерения_ПоследняяЦенаВРасходе"];
			
		ИначеЕсли СтрокаОперанда.Операнд = "[Себестоимость]" Тогда
			
			Значение 			= СтрокаКоллекции["Значение_Себестоимость"];
			ЗначениеКурс 			= СтрокаКоллекции["Курс_Себестоимость"];
			ЗначениеКратность		= СтрокаКоллекции["Кратность_Себестоимость"];
			ЗначениеНовыйКурс		= РасчетныеДанные.Курс;
			ЗначениеНоваяКратность	= РасчетныеДанные.Кратность;
			
			КлючЕдиницыИзмерения = "ЕдиницаИзмерения_Себестоимость";
			ЕдиницаИзмерения	= СтрокаКоллекции["ЕдиницаИзмерения_Себестоимость"];
			
		ИначеЕсли СтрокаОперанда.Операнд = "[СебестоимостьНацВалюта]" Тогда
			
			Значение 			= СтрокаКоллекции["Значение_СебестоимостьНацВалюта"];
			
			КлючЕдиницыИзмерения = "ЕдиницаИзмерения_СебестоимостьНацВалюта";
			ЕдиницаИзмерения	= СтрокаКоллекции["ЕдиницаИзмерения_СебестоимостьНацВалюта"];
			
		ИначеЕсли СтрокаОперанда.Операнд = "[ТекущееЗначение]" Тогда
			
			Значение 			= СтрокаКоллекции["ТекущееЗначение"];
			
			КлючЕдиницыИзмерения = "ЕдиницаИзмерения_ТекущееЗначение";
			ЕдиницаИзмерения	= СтрокаКоллекции.Номенклатура.ЕдиницаИзмерения;
			
		Иначе
			
			Значение 			= СтрокаОперанда.Значение;
			
			КлючЕдиницыИзмерения = "ЕдиницаИзмерения_Базовая";
			ЕдиницаИзмерения	= СтрокаКоллекции.Номенклатура.ЕдиницаИзмерения;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Значение) Тогда
			
			ФорматСтрокиЗначение= "ЧЦ=15; ЧДЦ=3; ЧРД=.; ЧГ=0";
			ФорматСтрокиКурс	= "ЧЦ=15; ЧДЦ=4; ЧРД=.; ЧГ=0";
			
			Если Число(ЗначениеКурс) = Число(ЗначениеНовыйКурс)
				И Число(ЗначениеКратность) = Число(ЗначениеНоваяКратность) Тогда
				
				Значение = Формат(Число(Значение), ФорматСтрокиЗначение);
				
			Иначе
				
				// (Значение * ЗначениеКурса * ЗначениеНовойКратности) / (ЗначениеНовогоКурса * ЗначениеКратность)"
				ШаблонРасчетаЗначения = "((%1 * %2 * %3) / (%4 * %5))";
				
				Значение = СтрШаблон(ШаблонРасчетаЗначения,
					Формат(Число(Значение), 				ФорматСтрокиЗначение),
					Формат(Число(ЗначениеКурс),				ФорматСтрокиКурс),
					Формат(Число(ЗначениеНоваяКратность),	ФорматСтрокиКурс),
					Формат(Число(ЗначениеНовыйКурс),		ФорматСтрокиКурс),
					Формат(Число(ЗначениеКратность),		ФорматСтрокиКурс)
				);
				
			КонецЕсли;
			
		Иначе
			
			Значение = 0;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
			
			СоответствиеОперандов.Вставить(КлючЕдиницыИзмерения, ЕдиницаИзмерения);
			
			Если НЕ ЗначениеЗаполнено(СтрокаКоллекции.ЕдиницаИзмерения) Тогда
				
				СтрокаКоллекции.ЕдиницаИзмерения = ЕдиницаИзмерения;
				
			КонецЕсли;
			
			Если СтрокаКоллекции.ЕдиницаИзмерения <> ЕдиницаИзмерения Тогда
				
				Значение = "(" + Значение + " * " + ЦенообразованиеСервер.ПересчетЕдиницИзмерения(ЕдиницаИзмерения, СтрокаКоллекции.ЕдиницаИзмерения, Истина) + ")";
				
			КонецЕсли;
			
		КонецЕсли;
		
		СоответствиеОперандов.Вставить(СтрокаОперанда.Операнд, Значение);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ТранспонироватьТаблицыКоллекцийИОперандов(КоллекцияНоменклатуры, ТаблицаОперандов, СоответствиеОперандов, ИспользуетсяТекущееЗначение, ЭтоКоллекцияСИндексами)
	
	ИменаПараметров		= "";
	ШаблонИмениПараметра=
		"	,%1.Значение КАК Значение_%1
		|	,%1.ЕдиницаИзмерения КАК ЕдиницаИзмерения_%1
		|	,%1.Курс КАК Курс_%1
		|	,%1.Кратность КАК Кратность_%1";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КоллекцияНоменклатуры", КоллекцияНоменклатуры);
	
	Шаблон_ПараметрВидЦен = 
	"ВЫБРАТЬ 
	|	КоллекцияЗначенийПараметра.Номенклатура
	|	,КоллекцияЗначенийПараметра.Характеристика
	|	,КоллекцияЗначенийПараметра.Значение КАК Значение
	|	,КоллекцияЗначенийПараметра.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|	,КоллекцияЗначенийПараметра.Курс КАК Курс
	|	,КоллекцияЗначенийПараметра.Кратность КАК Кратность
	|ПОМЕСТИТЬ КоллекцияЗначенийПараметра
	|ИЗ
	|	&КоллекцияЗначенийПараметра КАК КоллекцияЗначенийПараметра 
	|
	|ГДЕ
	|	КоллекцияЗначенийПараметра.ВидЦен = &ИмяПараметраВидЦен
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КоллекцияЗначенийПараметра.Номенклатура, 
	|	КоллекцияЗначенийПараметра.Характеристика;
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Шаблон_ПараметрЛевоеСоединение = "
	|	ЛЕВОЕ СОЕДИНЕНИЕ КоллекцияЗначенийПараметра КАК КоллекцияЗначенийПараметра
	|	ПО КоллекцияНоменклатуры.Номенклатура = КоллекцияЗначенийПараметра.Номенклатура
	|		И КоллекцияНоменклатуры.Характеристика = КоллекцияЗначенийПараметра.Характеристика
	|";
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КоллекцияНоменклатуры.Период
	|	,КоллекцияНоменклатуры.ВидЦен
	|	,КоллекцияНоменклатуры.Номенклатура
	|	,КоллекцияНоменклатуры.Характеристика
	|	,КоллекцияНоменклатуры.Цена
	|	,КоллекцияНоменклатуры.ТекущееЗначение
	|	,КоллекцияНоменклатуры.КлючСвязиНоменклатура
	|	,КоллекцияНоменклатуры.КлючСвязиХарактеристика
	|	,КоллекцияНоменклатуры.Актуальность
	|	,КоллекцияНоменклатуры.ЕдиницаИзмерения
	|	,КоллекцияНоменклатуры.ВключаяХарактеристики
	|	,КоллекцияНоменклатуры.Автор
	|	,Выразить(КоллекцияНоменклатуры.Формула КАК Строка(1024)) КАК Формула
	|	,КоллекцияНоменклатуры.ПересчетВыполнен
	|ПОМЕСТИТЬ КоллекцияНоменклатуры
	|ИЗ
	|	&КоллекцияНоменклатуры КАК КоллекцияНоменклатуры
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КоллекцияНоменклатуры.Номенклатура
	|	,КоллекцияНоменклатуры.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоллекцияНоменклатуры.Период
	|	,КоллекцияНоменклатуры.ВидЦен
	|	,КоллекцияНоменклатуры.Номенклатура
	|	,КоллекцияНоменклатуры.Характеристика
	|	,КоллекцияНоменклатуры.Цена
	|	,КоллекцияНоменклатуры.ТекущееЗначение
	|	,КоллекцияНоменклатуры.КлючСвязиНоменклатура
	|	,КоллекцияНоменклатуры.КлючСвязиХарактеристика
	|	,КоллекцияНоменклатуры.Актуальность
	|	,КоллекцияНоменклатуры.ЕдиницаИзмерения
	|	,КоллекцияНоменклатуры.ВключаяХарактеристики
	|	,КоллекцияНоменклатуры.Автор
	|	,КоллекцияНоменклатуры.Формула
	|	,КоллекцияНоменклатуры.ПересчетВыполнен
	|	,&ИменаПараметров
	|ИЗ
	|	КоллекцияНоменклатуры КАК КоллекцияНоменклатуры";
	
	Если НЕ ИспользуетсяТекущееЗначение Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, ",КоллекцияНоменклатуры.ТекущееЗначение", "");
		
	КонецЕсли;
	
	Если НЕ ЭтоКоллекцияСИндексами Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, ",КоллекцияНоменклатуры.КлючСвязиНоменклатура", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, ",КоллекцияНоменклатуры.КлючСвязиХарактеристика", "");
		
	КонецЕсли;
	
	Для каждого СтрокаОперанда Из ТаблицаОперандов Цикл
		
		СоответствиеОперандов.Вставить(СтрокаОперанда.Операнд, 0);
		
		Если ТипЗнч(СтрокаОперанда.Значение) = Тип("ТаблицаЗначений") Тогда
			
			Если СтрокаОперанда.ЭтоЦеныНоменклатуры <> Неопределено Тогда
				
				Идентификатор = СтрокаОперанда.ВидЦен.ИдентификаторФормул;
				Запрос.УстановитьПараметр("Параметр_" + Идентификатор, СтрокаОперанда.ВидЦен);
				
				ТекстЗапросаКоллекцияПараметров = СтрЗаменить(Шаблон_ПараметрВидЦен, "&ИмяПараметраВидЦен", "&Параметр_" + Идентификатор);
				
			ИначеЕсли СтрокаОперанда.Операнд = "[ПоследняяЦенаВПриходе]" Тогда
				
				Идентификатор = "ПоследняяЦенаВПриходе";
				
				УдаляемыйТекст = "ГДЕ
								|	КоллекцияЗначенийПараметра.ВидЦен = &ИмяПараметраВидЦен";
				ТекстЗапросаКоллекцияПараметров = СтрЗаменить(Шаблон_ПараметрВидЦен, УдаляемыйТекст, "");
				
			ИначеЕсли СтрокаОперанда.Операнд = "[ПоследняяЦенаВРасходе]" Тогда
				
				Идентификатор = "ПоследняяЦенаВРасходе";
				
				УдаляемыйТекст = "ГДЕ
								|	КоллекцияЗначенийПараметра.ВидЦен = &ИмяПараметраВидЦен";
				ТекстЗапросаКоллекцияПараметров = СтрЗаменить(Шаблон_ПараметрВидЦен, УдаляемыйТекст, "");
				
			ИначеЕсли СтрокаОперанда.Операнд = "[Себестоимость]" Тогда
				
				Идентификатор = "Себестоимость";
				
				УдаляемыйТекст = "ГДЕ
								|	КоллекцияЗначенийПараметра.ВидЦен = &ИмяПараметраВидЦен";
				ТекстЗапросаКоллекцияПараметров = СтрЗаменить(Шаблон_ПараметрВидЦен, УдаляемыйТекст, "");
				
				ВалютаУчета = Константы.ВалютаУчета.Получить();
				НациональнаяВалюта = Константы.НациональнаяВалюта.Получить();
				Если ВалютаУчета = НациональнаяВалюта Тогда
					
					ТекстЗапросаКоллекцияПараметров = СтрЗаменить(ТекстЗапросаКоллекцияПараметров, "КоллекцияЗначенийПараметра.Курс", "1");
					ТекстЗапросаКоллекцияПараметров = СтрЗаменить(ТекстЗапросаКоллекцияПараметров, "КоллекцияЗначенийПараметра.Кратность", "1");
					
				Иначе
					
					КурсВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаУчета, ТекущаяДатаСеанса());
					ТекстЗапросаКоллекцияПараметров = СтрЗаменить(ТекстЗапросаКоллекцияПараметров, "КоллекцияЗначенийПараметра.Курс", СтрЗаменить(Строка(КурсВалюты.Курс), ",", "."));
					ТекстЗапросаКоллекцияПараметров = СтрЗаменить(ТекстЗапросаКоллекцияПараметров, "КоллекцияЗначенийПараметра.Кратность", СтрЗаменить(Строка(КурсВалюты.Кратность), ",", "."));
					
				КонецЕсли;
				
			ИначеЕсли СтрокаОперанда.Операнд = "[СебестоимостьНацВалюта]" Тогда
				
				КурсВалютыУчета = ТаблицаОперандов.Найти("[КурсВалютыУчета]", "Операнд").Значение;
				
				Если НЕ ЗначениеЗаполнено(КурсВалютыУчета) Тогда
					
					КурсВалютыУчета = 1;
					
				КонецЕсли;
				
				Идентификатор = "СебестоимостьНацВалюта";
				
				УдаляемыйТекст = "ГДЕ
								|	КоллекцияЗначенийПараметра.ВидЦен = &ИмяПараметраВидЦен";
				ТекстЗапросаКоллекцияПараметров = СтрЗаменить(Шаблон_ПараметрВидЦен, УдаляемыйТекст, "");
				
				ЗаменяемаяСтрокаЗапроса = ",КоллекцияЗначенийПараметра.Значение КАК Значение";
				НоваяСтрокаЗапроса = ",КоллекцияЗначенийПараметра.Значение * &КурсВалютыУчета КАК Значение";
				ТекстЗапросаКоллекцияПараметров = СтрЗаменить(ТекстЗапросаКоллекцияПараметров, ЗаменяемаяСтрокаЗапроса, НоваяСтрокаЗапроса);
				Запрос.УстановитьПараметр("КурсВалютыУчета", КурсВалютыУчета);
				
				ТекстЗапросаКоллекцияПараметров = СтрЗаменить(ТекстЗапросаКоллекцияПараметров, "КоллекцияЗначенийПараметра.Курс", "1");
				ТекстЗапросаКоллекцияПараметров = СтрЗаменить(ТекстЗапросаКоллекцияПараметров, "КоллекцияЗначенийПараметра.Кратность", "1");
				
			КонецЕсли;
			
			ТекстЗапросаКоллекцияПараметров = СтрЗаменить(ТекстЗапросаКоллекцияПараметров,	"КоллекцияЗначенийПараметра", Идентификатор);
			ТекстЗапросаЛевоеСоединение		= СтрЗаменить(Шаблон_ПараметрЛевоеСоединение,	"КоллекцияЗначенийПараметра", Идентификатор);
			ИменаПараметров 				= ИменаПараметров + СтрШаблон(ШаблонИмениПараметра, Идентификатор);
			
			Запрос.УстановитьПараметр(Идентификатор, СтрокаОперанда.Значение);
			
			Запрос.Текст = ТекстЗапросаКоллекцияПараметров + Запрос.Текст + ТекстЗапросаЛевоеСоединение;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "	,&ИменаПараметров", ИменаПараметров);
	
	КоллекцияНоменклатуры = Запрос.Выполнить().Выгрузить();

КонецПроцедуры

Процедура РасчитатьДанныеКоллекции(КоллекцияНоменклатуры, ТаблицаОперандов, ПараметрыРасчета, ИспользуетсяТекущееЗначение = Ложь, ЭтоКоллекцияСИндексами = Ложь) Экспорт
	Перем ВидЦен, ОкруглятьВБольшуюСторону, ПравилоОкругления;
	
	Если ЗначениеЗаполнено(ПараметрыРасчета.ВидЦен) Тогда
		
		ОкруглятьВБольшуюСторону = ПараметрыРасчета.ВидЦен.ОкруглятьВБольшуюСторону;
		ПравилоОкругления = ПараметрыРасчета.ВидЦен.ПорядокОкругления;
		
	КонецЕсли;
	
	АвторизованныйПользователь	= Пользователи.АвторизованныйПользователь();
	
	СоответствиеОперандов		= Новый Соответствие;
	ТранспонироватьТаблицыКоллекцийИОперандов(КоллекцияНоменклатуры, ТаблицаОперандов, СоответствиеОперандов, ИспользуетсяТекущееЗначение, ЭтоКоллекцияСИндексами);
	
	КоличествоЗаписей = КоллекцияНоменклатуры.Количество();
	ИспользуетсяАвтор = (КоллекцияНоменклатуры.Колонки.Найти("Автор") <> Неопределено);
	
	РасчетныеДанные = Новый Структура("Цена, Курс, Кратность, ЕдиницаИзмерения, ОшибкаРасчета, ТекстОшибки");
	
	Пока КоличествоЗаписей > 0 Цикл
		
		СтрокаКоллекции = КоллекцияНоменклатуры.Получить(КоличествоЗаписей - 1);
		КоличествоЗаписей = КоличествоЗаписей - 1;
		
		Если ПустаяСтрока(СтрокаКоллекции.Формула) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если ИспользуетсяАвтор
			И НЕ ЗначениеЗаполнено(СтрокаКоллекции.Автор) Тогда
			
			СтрокаКоллекции.Автор = АвторизованныйПользователь;
			
		КонецЕсли;
		
		Если СтрокаКоллекции.Цена = 0 Тогда
			
			СоответствиеОперандов.Очистить();
			
			РасчетныеДанные.Цена			= 0;
			РасчетныеДанные.Курс			= ПараметрыРасчета.Курс;
			РасчетныеДанные.Кратность		= ПараметрыРасчета.Кратность;
			РасчетныеДанные.ЕдиницаИзмерения= СтрокаКоллекции.ЕдиницаИзмерения;
			РасчетныеДанные.ОшибкаРасчета	= Ложь;
			РасчетныеДанные.ТекстОшибки		= Неопределено;
			
			ПодготовитьДанныеСтрокиКоллекции(СоответствиеОперандов, СтрокаКоллекции, ТаблицаОперандов, РасчетныеДанные);
			
			РасчетДанныхПоФормуле(СтрокаКоллекции.Формула, СоответствиеОперандов, РасчетныеДанные, ОкруглятьВБольшуюСторону, ПравилоОкругления);
			
			СтрокаКоллекции.Цена = РасчетныеДанные.Цена;
			Если НЕ ЗначениеЗаполнено(СтрокаКоллекции.ЕдиницаИзмерения) Тогда
				
				СтрокаКоллекции.ЕдиницаИзмерения = РасчетныеДанные.ЕдиницаИзмерения;
				
			ИначеЕсли ЗначениеЗаполнено(РасчетныеДанные.ЕдиницаИзмерения)
				И СтрокаКоллекции.ЕдиницаИзмерения <> РасчетныеДанные.ЕдиницаИзмерения Тогда
				
				Если ТипЗнч(РасчетныеДанные.ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
					
					СтрокаКоллекции.Цена = СтрокаКоллекции.Цена / РасчетныеДанные.ЕдиницаИзмерения.Коэффициент;
					
				ИначеЕсли ТипЗнч(СтрокаКоллекции.ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
					
					СтрокаКоллекции.Цена = СтрокаКоллекции.Цена * СтрокаКоллекции.ЕдиницаИзмерения.Коэффициент;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ ЭтоКоллекцияСИндексами 
			И НЕ ЗначениеЗаполнено(СтрокаКоллекции.Цена) Тогда
			
			КоллекцияНоменклатуры.Удалить(СтрокаКоллекции);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


