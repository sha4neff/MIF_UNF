#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВременныеТаблицыВоронкиПродаж(НастройкиКД) Экспорт
	
	Результат = Новый МенеджерВременныхТаблиц;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	&ПолеГруппировки КАК ПолеГруппировки,
	|	ИсторияСостоянийЛидов.Лид КАК Лид,
	|	ИсторияСостоянийЛидов.Лид.СостояниеЛида КАК Состояние
	|ПОМЕСТИТЬ ВТ_Лиды
	|ИЗ
	|	РегистрСведений.ИсторияСостоянийЛидов КАК ИсторияСостоянийЛидов
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &КонецПериода = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИсторияСостоянийЛидов.Период >= &НачалоПериода
	|			ИНАЧЕ ИсторияСостоянийЛидов.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|		КОНЕЦ
	|	И ИсторияСостоянийЛидов.Лид.ЭтоГруппа = ЛОЖЬ
	|	И &Фильтры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_Лиды.ПолеГруппировки КАК ПолеГруппировки,
	|	ВТ_Лиды.Лид КАК Лид,
	|	СостоянияЛидов.РеквизитДопУпорядочивания КАК Порядок,
	|	СостоянияЛидов.Ссылка КАК Состояние,
	|	СостоянияЛидов1.Ссылка КАК СледующееСостояние
	|ПОМЕСТИТЬ ВТ_Состояния
	|ИЗ
	|	ВТ_Лиды КАК ВТ_Лиды
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СостоянияЛидов КАК СостоянияЛидов
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СостоянияЛидов КАК СостоянияЛидов1
	|			ПО СостоянияЛидов.Ссылка = СостоянияЛидов1.Ссылка
	|				И (СостоянияЛидов1.РеквизитДопУпорядочивания = СостоянияЛидов.РеквизитДопУпорядочивания + 1)
	|		ПО (ВТ_Лиды.Состояние <> СостоянияЛидов.Ссылка
	|				ИЛИ ВТ_Лиды.Состояние = СостоянияЛидов.Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИсторияСостоянийЛидовСрезПоследних.Лид КАК Лид,
	|	ИсторияСостоянийЛидовСрезПоследних.Состояние КАК Состояние,
	|	ИсторияСостоянийЛидовСрезПоследних.Период КАК ПоследнийПериод,
	|	СостоянияЛидов.РеквизитДопУпорядочивания КАК ПоследнийПорядок
	|ПОМЕСТИТЬ ВТ_СрезПоследних
	|ИЗ
	|	ВТ_Лиды КАК ВТ_Лиды
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийЛидов.СрезПоследних(
	|				,
	|				Лид В
	|					(ВЫБРАТЬ
	|						ВТ_Лиды.Лид
	|					ИЗ
	|						ВТ_Лиды)) КАК ИсторияСостоянийЛидовСрезПоследних
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СостоянияЛидов КАК СостоянияЛидов
	|			ПО ИсторияСостоянийЛидовСрезПоследних.Состояние = СостоянияЛидов.Ссылка
	|		ПО ВТ_Лиды.Лид = ИсторияСостоянийЛидовСрезПоследних.Лид
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИсторияСостоянийЛидовСрезПоследних.Лид КАК Лид,
	|	ИсторияСостоянийЛидовСрезПоследних.Состояние КАК Состояние,
	|	ИсторияСостоянийЛидовСрезПоследних.Период КАК ПоследнийПериод,
	|	СостоянияЛидов.РеквизитДопУпорядочивания КАК ПоследнийПорядок
	|ПОМЕСТИТЬ ВТ_СрезПоследнихДоОтмены
	|ИЗ
	|	ВТ_Лиды КАК ВТ_Лиды
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийЛидов.СрезПоследних(
	|				,
	|				Лид.ВариантЗавершения = ЗНАЧЕНИЕ(Перечисление.ВариантЗавершенияРаботыСЛидом.НекачественныйЛид)
	|					И Состояние <> ЗНАЧЕНИЕ(Справочник.СостоянияЛидов.Завершен)
	|					И Лид В
	|						(ВЫБРАТЬ
	|							ВТ_Лиды.Лид
	|						ИЗ
	|							ВТ_Лиды)) КАК ИсторияСостоянийЛидовСрезПоследних
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СостоянияЛидов КАК СостоянияЛидов
	|			ПО ИсторияСостоянийЛидовСрезПоследних.Состояние = СостоянияЛидов.Ссылка
	|		ПО ВТ_Лиды.Лид = ИсторияСостоянийЛидовСрезПоследних.Лид
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТ_Состояния.ПолеГруппировки КАК ПолеГруппировки,
	|	ВТ_Состояния.Лид КАК Лид,
	|	ВТ_Состояния.Порядок КАК Порядок,
	|	ВТ_Состояния.Состояние КАК Состояние,
	|	ИсторияСостоянийЛидов.Период КАК Старт,
	|	ИсторияСостоянийЛидов1.Период КАК Финиш,
	|	ВТ_СрезПоследних.ПоследнийПериод КАК ДатаПоследнегоСостояния,
	|	ВТ_СрезПоследних.ПоследнийПорядок КАК ПорядокПоследнегоСостояния,
	|	ВЫБОР
	|		КОГДА ИсторияСостоянийЛидов1.Период ЕСТЬ NULL
	|			ТОГДА РАЗНОСТЬДАТ(ИсторияСостоянийЛидов.Период, ВТ_СрезПоследних.ПоследнийПериод, СЕКУНДА)
	|		ИНАЧЕ РАЗНОСТЬДАТ(ИсторияСостоянийЛидов.Период, ИсторияСостоянийЛидов1.Период, СЕКУНДА)
	|	КОНЕЦ КАК Длительность,
	|	ВЫБОР
	|		КОГДА ВТ_Состояния.Лид.ВариантЗавершения = ЗНАЧЕНИЕ(Перечисление.ВариантЗавершенияРаботыСЛидом.НекачественныйЛид)
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_СрезПоследнихДоОтмены.ПоследнийПорядок >= ВТ_Состояния.Порядок
	|						ТОГДА 1
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ВТ_СрезПоследних.ПоследнийПорядок >= ВТ_Состояния.Порядок
	|					ТОГДА 1
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|	КОНЕЦ КАК УчитыватьВВоронке
	|ПОМЕСТИТЬ ВТ_ДанныеВоронкиПродаж
	|ИЗ
	|	ВТ_Состояния КАК ВТ_Состояния
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийЛидов КАК ИсторияСостоянийЛидов
	|		ПО ВТ_Состояния.Лид = ИсторияСостоянийЛидов.Лид
	|			И ВТ_Состояния.Состояние = ИсторияСостоянийЛидов.Состояние
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийЛидов КАК ИсторияСостоянийЛидов1
	|		ПО ВТ_Состояния.Лид = ИсторияСостоянийЛидов1.Лид
	|			И ВТ_Состояния.СледующееСостояние = ИсторияСостоянийЛидов1.Состояние
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СрезПоследних КАК ВТ_СрезПоследних
	|		ПО ВТ_Состояния.Лид = ВТ_СрезПоследних.Лид
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СрезПоследнихДоОтмены КАК ВТ_СрезПоследнихДоОтмены
	|		ПО ВТ_Состояния.Лид = ВТ_СрезПоследнихДоОтмены.Лид";
	
	Запрос = Новый Запрос(ТекстЗапросаСУстановленнымПолемГруппировки(ТекстЗапроса, "ИсторияСостоянийЛидов", НастройкиКД));
	
	Запрос.УстановитьПараметр("НачалоПериода", НастройкиКД.ПараметрыДанных.Элементы.Найти("СтПериод").Значение.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", НастройкиКД.ПараметрыДанных.Элементы.Найти("СтПериод").Значение.ДатаОкончания);
	
	МассивФильтров = Новый Массив;
	
	ДоступныеПоляОтбора = ДоступныеПоляОтбора(НастройкиКД);
	
	Для Каждого ТекЭлементОтбора Из НастройкиКД.Отбор.Элементы Цикл
		
		Если Не ТекЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ТекЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			
			Для Каждого ТекЭлементГруппыОтбора Из ТекЭлементОтбора.Элементы Цикл
				
				ИмяПараметра = "Значение" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
				ТекстФильтра = СтрокаОтбора(ТекЭлементГруппыОтбора, ИмяПараметра);
				Если ПустаяСтрока(ТекстФильтра) Тогда
					Продолжить;
				КонецЕсли;
				
				Если ТекЭлементОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
					МассивФильтров.Добавить(СтрШаблон("НЕ (%1)", ТекстФильтра));
				Иначе
					МассивФильтров.Добавить(ТекстФильтра);
				КонецЕсли;
				
				Запрос.УстановитьПараметр(ИмяПараметра, ?(ТипЗнч(ТекЭлементГруппыОтбора.ПравоеЗначение) = Тип("СписокЗначений"), ТекЭлементГруппыОтбора.ПравоеЗначение.ВыгрузитьЗначения(), ТекЭлементГруппыОтбора.ПравоеЗначение));
				
			КонецЦикла;
			
		ИначеЕсли ЭтоОтборПоДопРеквизиту(ТекЭлементОтбора) Тогда
			
			ИмяПараметраСвойство = "Свойство" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
			ИмяПараметраЗначение = "Значение" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
			
			ТекстФильтра = СтрокаОтбораПоДопРеквизиту(ТекЭлементОтбора, ИмяПараметраСвойство, ИмяПараметраЗначение, ДоступныеПоляОтбора);
			Если ПустаяСтрока(ТекстФильтра) Тогда
				Продолжить;
			КонецЕсли;
			
			МассивФильтров.Добавить(ТекстФильтра);
			Запрос.УстановитьПараметр(ИмяПараметраСвойство, ЗначениеПараметраСвойство(ТекЭлементОтбора));
			Запрос.УстановитьПараметр(ИмяПараметраЗначение, ?(ТипЗнч(ТекЭлементОтбора.ПравоеЗначение) = Тип("СписокЗначений"), ТекЭлементОтбора.ПравоеЗначение.ВыгрузитьЗначения(), ТекЭлементОтбора.ПравоеЗначение));
			
		Иначе
			
			ИмяПараметра = "Значение" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
			
			ТекстФильтра = СтрокаОтбора(ТекЭлементОтбора, ИмяПараметра);
			Если ПустаяСтрока(ТекстФильтра) Тогда
				Продолжить;
			КонецЕсли;
			
			МассивФильтров.Добавить(ТекстФильтра);
			Запрос.УстановитьПараметр(ИмяПараметра, ?(ТипЗнч(ТекЭлементОтбора.ПравоеЗначение) = Тип("СписокЗначений"), ТекЭлементОтбора.ПравоеЗначение.ВыгрузитьЗначения(), ТекЭлементОтбора.ПравоеЗначение));
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(МассивФильтров) Тогда
		СтрПараметрФильтры = СтрСоединить(МассивФильтров, Символы.ПС + " И ");
	Иначе
		СтрПараметрФильтры = "ИСТИНА";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Фильтры", СтрПараметрФильтры);
	
	Запрос.МенеджерВременныхТаблиц = Результат;
	
	Запрос.Выполнить();
	
	Возврат Результат;
	
КонецФункции

Функция ВариантВоронки(НастройкиКД) Экспорт
	
	Возврат НастройкиКД.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВариантВоронки")).Значение;
	
КонецФункции

Функция ТекстЗапросаСУстановленнымПолемГруппировки(ТекстЗапроса, ИмяТаблицы, НастройкиКД) Экспорт
	
	Возврат СтрЗаменить(ТекстЗапроса, "&ПолеГруппировки", ПутьПоляГруппировки(ИмяТаблицы, НастройкиКД));
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтрокаОтбора(ЭлементОтбора, ИмяПараметра)
	
	КомпонентыПути = СтрРазделить(ЭлементОтбора.ЛевоеЗначение, ".");
	
	Если КомпонентыПути.Найти("Контрагент") <> Неопределено
		И КомпонентыПути.Найти("Тег") <> Неопределено Тогда
		Возврат СтрокаОтбораПоТегуКонтрагента(ЭлементОтбора, ИмяПараметра);
	КонецЕсли;
	
	Если КомпонентыПути.Найти("Лид") = Неопределено Тогда
		Результат = СтрШаблон("ИсторияСостоянийЛидов.Лид.%1", ЭлементОтбора.ЛевоеЗначение);
	Иначе
		Результат = СтрШаблон("ИсторияСостоянийЛидов.%1", ЭлементОтбора.ЛевоеЗначение);
	КонецЕсли;
	
	Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии Тогда
		
		Результат = СтрШаблон("%1 В ИЕРАРХИИ (&%2)", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
		
		Результат = СтрШаблон("%1 В (&%2)", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеНачинаетсяС
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НачинаетсяС Тогда
		
		Результат = СтрШаблон("%1 ПОДОБНО &%2+""%%""", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеПодобно
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Подобно Тогда
		
		Результат = СтрШаблон("%1 ПОДОБНО &%2", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеСодержит
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит Тогда
		
		Результат = СтрШаблон("%1 ПОДОБНО ""%%""+&%2+""%%""", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
		
		Результат = СтрШаблон("%1 = &%2", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше Тогда 
		
		Результат = СтрШаблон("%1 > &%2", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно Тогда 
		
		Результат = СтрШаблон("%1 >= &%2", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше Тогда 
		
		Результат = СтрШаблон("%1 < &%2", Результат, ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда 
		
		Результат = СтрШаблон("%1 <= &%2", Результат, ИмяПараметра);
		
	КонецЕсли;
	
	Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеНачинаетсяС
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеПодобно
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено
		ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеСодержит Тогда
		Результат = СтрШаблон("НЕ (%1)", Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЭтоОтборПоДопРеквизиту(ЭлементОтбора)
	
	Возврат СтрНайти(ЭлементОтбора.ЛевоеЗначение, ".[") > 0
	И СтрЗаканчиваетсяНа(ЭлементОтбора.ЛевоеЗначение, "]");
	
КонецФункции

Функция СтрокаОтбораПоДопРеквизиту(ЭлементОтбора, ИмяПараметраСвойство, ИмяПараметраЗначение, ДоступныеПоляОтбора)
	
	Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		ЧастицаНе = "НЕ ";
	КонецЕсли;
	
	ЗапросОбъектовПоЗначениюДопРеквизитов = ЗапросОбъектовПоЗначениюДопРеквизитов(ЭлементОтбора, ИмяПараметраСвойство, ИмяПараметраЗначение, ДоступныеПоляОтбора);
	Если Не ЗначениеЗаполнено(ЗапросОбъектовПоЗначениюДопРеквизитов) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтрШаблон("ИсторияСостоянийЛидов.%1
	|%2В (%3)",
	ИмяПоляВладелецДопРеквизита(ЭлементОтбора),
	ЧастицаНе,
	ЗапросОбъектовПоЗначениюДопРеквизитов);
	
КонецФункции

Функция ДоступныеПоляОтбора(НастройкиКД)
	
	Если ЗначениеЗаполнено(НастройкиКД.ДоступныеПоляОтбора.Элементы) Тогда
		Возврат НастройкиКД.ДоступныеПоляОтбора;
	КонецЕсли;
	
	Если Не НастройкиКД.ДополнительныеСвойства.Свойство("АдресСхемы") Тогда
		Возврат НастройкиКД.ДоступныеПоляОтбора;
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиКД.ДополнительныеСвойства.АдресСхемы));
	Возврат КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора;
	
КонецФункции

Функция ЗначениеПараметраСвойство(ЭлементОтбора)
	
	Для Каждого ТекКомпонент Из СтрРазделить(ЭлементОтбора.ЛевоеЗначение, ".") Цикл
		
		Если СтрНачинаетсяС(ТекКомпонент, "[")
			И СтрЗаканчиваетсяНа(ТекКомпонент, "]") Тогда
			НаименованиеСвойства = Сред(ТекКомпонент, 2, СтрДлина(ТекКомпонент) - 2);
			Возврат ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(НаименованиеСвойства, Истина);
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

Функция ИмяПоляВладелецДопРеквизита(ЭлементОтбора)
	
	КомпонентыПути = СтрРазделить(ЭлементОтбора.ЛевоеЗначение, ".");
	Если КомпонентыПути.Найти("Лид") = Неопределено Тогда
		Возврат СтрШаблон("Лид.%1", КомпонентыПути[0]);
	Иначе 
		Возврат КомпонентыПути[0]
	КонецЕсли;
	
КонецФункции

Функция ЗапросОбъектовПоЗначениюДопРеквизитов(ЭлементОтбора, ИмяПараметраСвойство, ИмяПараметраЗначение, ДоступныеПоляОтбора)
	
	Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно 
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
		
		КомпонентСравнения = СтрШаблон("= &%1", ИмяПараметраЗначение);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке 
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
		
		КомпонентСравнения = СтрШаблон("В (&%1)", ИмяПараметраЗначение);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		
		КомпонентСравнения = СтрШаблон("В ИЕРАРХИИ (&%1)", ИмяПараметраЗначение);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КомпонентСравнения) Тогда
		Возврат "";
	КонецЕсли;
	
	КомпонентыПути = СтрРазделить(ЭлементОтбора.ЛевоеЗначение, ".");
	
	ПолеКД = ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(КомпонентыПути[0]));
	Если ПолеКД = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	МассивПодзапросов = Новый Массив;
	
	Для Каждого Тип Из ПолеКД.ТипЗначения.Типы() Цикл
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		
		МассивПодзапросов.Добавить(
		СтрШаблон("ВЫБРАТЬ
		|%1ДополнительныеРеквизиты.Ссылка
		|ИЗ
		|%2.%1.ДополнительныеРеквизиты КАК %1ДополнительныеРеквизиты
		|ГДЕ
		|%1ДополнительныеРеквизиты.Свойство = &%3
		|И  %1ДополнительныеРеквизиты.Значение %4",
		ОбъектМетаданных.Имя,
		ОбщегоНазначения.ВидОбъектаПоТипу(Тип),
		ИмяПараметраСвойство,
		КомпонентСравнения));
		
	КонецЦикла;
	
	Возврат СтрСоединить(МассивПодзапросов,
	"
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	
КонецФункции

Функция СтрокаОтбораПоТегуКонтрагента(ЭлементОтбора, ИмяПараметра)
	
	Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		ЧастицаНе = "НЕ ";
	КонецЕсли;
	
	Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно 
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
		
		КомпонентСравнения = СтрШаблон("= &%1", ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке 
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
		
		КомпонентСравнения = СтрШаблон("В (&%1)", ИмяПараметра);
		
	ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии
		Или ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		
		КомпонентСравнения = СтрШаблон("В ИЕРАРХИИ (&%1)", ИмяПараметра);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КомпонентСравнения) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтрШаблон("ИсторияСостоянийЛидов.Лид
	|%1В (ВЫБРАТЬ Ссылка ИЗ Справочник.Лиды.Теги
	|ГДЕ Тег %2)", ЧастицаНе, КомпонентСравнения);
	
КонецФункции

Функция ПутьПоляГруппировки(ИмяТаблицы, НастройкиКД)
	
	ВариантВоронки = ВариантВоронки(НастройкиКД);
	
	СоответствиеПолей = Новый Соответствие;
	СоответствиеПолей["ПоЛидам"] = "ЭтоГруппа";
	СоответствиеПолей["ПоМенеджерам"] = "Ответственный";
	СоответствиеПолей["ПоИсточникам"] = "ИсточникПривлечения";
	
	Возврат СтрШаблон("%1.Лид.%2%3", ИмяТаблицы, СоответствиеПолей[ВариантВоронки], СуффиксПутиПоляГруппировки(НастройкиКД, СоответствиеПолей[ВариантВоронки]));
КонецФункции

Функция СуффиксПутиПоляГруппировки(НастройкиКД, ИмяПоля)
	
	Для Каждого ТекЭлемент Из НастройкиКД.Отбор.Элементы Цикл
		
		Если ТипЗнч(ТекЭлемент) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ТекЭлемент.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекЭлемент.ЛевоеЗначение <> Новый ПолеКомпоновкиДанных(ИмяПоля) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеСодержитГруппы(ТекЭлемент.ПравоеЗначение) Тогда
			Возврат ".Родитель";
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

Функция ЗначениеСодержитГруппы(ПроверяемоеЗначение)
	
	Если ТипЗнч(ПроверяемоеЗначение) <> Тип("СписокЗначений") Тогда
		Возврат ЭтоГруппа(ПроверяемоеЗначение);
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ПроверяемоеЗначение Цикл
		Если ЭтоГруппа(ТекЭлемент.Значение) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ЭтоГруппа(ПроверяемоеЗначение)
	
	Если Не ОбщегоНазначения.ЗначениеСсылочногоТипа(ПроверяемоеЗначение) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МетаданныеОбъекта = ПроверяемоеЗначение.Метаданные();
	
	Если Не ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта("ЭтоГруппа", МетаданныеОбъекта) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроверяемоеЗначение, "ЭтоГруппа");
	
КонецФункции

#КонецОбласти

#КонецЕсли