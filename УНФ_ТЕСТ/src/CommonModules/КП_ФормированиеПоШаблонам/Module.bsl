// Общий модуль (выполняется на стороне сервера) модуля "Конструктор процессов для 1С:УНФ"
// Разработчик Компания "Аналитика. Проекты и решения" +7 495 005-1653, https://kp-unf.ru

#Область СлужебныеПроцедурыИФункции

// Функция возвращает массив областей шаблона файла, элемент массива состоит из структуры, 
// описавающей область документа. 
// Параметры:
//		ФайлШаблона - ссылка на файл шаблона
// Возвращаемое значение: Маасив областей шаблона
Функция ПолучитьМассивСтруктурОбластейШаблона(ФайлШаблона) Экспорт
	//получим данные об областях из запроса			
	Запрос=Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                    |	КП_ОбластиШаблоновФайлов.Наименование,
	                    |	КП_ОбластиШаблоновФайлов.ТипОбласти,
	                    |	КП_ОбластиШаблоновФайлов.ТабличнаяЧасть,
						|	КП_ОбластиШаблоновФайлов.НовыйРаздел,
	                    |	КП_ОбластиШаблоновФайлов.ПорядокВывода КАК ПорядокВывода
	                    |ИЗ
	                    |	Справочник.КП_ОбластиШаблоновФайлов КАК КП_ОбластиШаблоновФайлов
	                    |ГДЕ
	                    |	КП_ОбластиШаблоновФайлов.ПометкаУдаления = ЛОЖЬ
	                    |	И КП_ОбластиШаблоновФайлов.Владелец = &Файл
	                    |	И КП_ОбластиШаблоновФайлов.Отключено = ЛОЖЬ
	                    |
	                    |УПОРЯДОЧИТЬ ПО
	                    |	ПорядокВывода");
	Запрос.УстановитьПараметр("Файл", ФайлШаблона);
	ВыборкаОбласти=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	МассивОбластей=Новый Массив;
	СтруктураОбластей=Новый Структура("Наименование, ТипОбласти, ТабличнаяЧасть");
	
	Пока ВыборкаОбласти.Следующий() Цикл
		ИмяТабличнойЧасти=КП_ОбщееСервер.ПолучитьИмяТЧПоПредставлению(ВыборкаОбласти.ТабличнаяЧасть);
		СтруктураОбластей=Новый Структура("Наименование, ТипОбласти, ТабличнаяЧасть", ВыборкаОбласти.Наименование, ВыборкаОбласти.ТипОбласти, ИмяТабличнойЧасти);
		СтруктураОбластей.Вставить("НовыйРаздел", ВыборкаОбласти.НовыйРаздел); 
		МассивОбластей.Добавить(СтруктураОбластей);
	КонецЦикла;
	
	Возврат МассивОбластей;
	
КонецФункции

// Функция возвращает строковое обозначение типа области, переданного в аргументе функции
// Параметры:
//		ТипОбласти - Название типа области
// Возвращаемое значение: Строка
Функция ПолучитьПреобразованныйТипОбласти(ТипОбласти) Экспорт
	
	Если ТипОбласти="Строка таблицы" Тогда
		Возврат "СтрокаТаблицы";
	ИначеЕсли ТипОбласти="Шапка таблицы" Тогда
		Возврат "ШапкаТаблицы";
	ИначеЕсли ТипОбласти="Верхний колонтитул" Тогда
		Возврат "ВерхнийКолонтитул";
	ИначеЕсли ТипОбласти="Нижний колонтитул" Тогда
		Возврат "НижнийКолонтитул";
	Иначе
		Возврат ТипОбласти;
	КонецЕсли;
		
КонецФункции

#КонецОбласти
