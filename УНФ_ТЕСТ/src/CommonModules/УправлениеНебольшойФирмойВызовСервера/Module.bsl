
#Область ПрограммныйИнтерфейс

Функция ДатаСервера() Экспорт
	
	Возврат ТекущаяДата();
	
КонецФункции

Функция ДатаСеанса() Экспорт
	
	Возврат ТекущаяДатаСеанса();
	
КонецФункции

// Функция формирует структуру с данными для печати на принтере этикеток.
Функция ПодготовитьСтруктуруДанныхЦенниковИЭтикетокДляПринтераЭтикеток(Знач Параметры, Знач МенеджерПечати, Размер) Экспорт
	
	МенеджерПечати = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МенеджерПечати);
	
	Данные = МенеджерПечати.ПолучитьДанныеДляПринтераЭтикеток(Параметры);
	
	Результат = Новый Массив;
	
	Для Каждого ТекШаблон Из Данные Цикл
		
		Если ТекШаблон.Шаблон.РазмерМакета = Размер Тогда
			
			Пакет = Новый Структура;
			Пакет.Вставить("XML", ТекШаблон.ТабличныйДокумент.XML);
			Пакет.Вставить("Этикетки", Новый Массив);
			
			Для Каждого ТекЭтикетка Из ТекШаблон.ТабличныйДокумент.Этикетки Цикл
				
				НоваяЭтикетка = Новый Структура;
				НоваяЭтикетка.Вставить("Количество", ТекЭтикетка.Количество);
				НоваяЭтикетка.Вставить("Поля", ТекЭтикетка.ЗначенияПолей);
				
				Пакет.Этикетки.Добавить(НоваяЭтикетка);
				
			КонецЦикла;
			
			Результат.Добавить(Пакет);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает значение функциональной опции по имени. Для использования на клиенте.
Функция ПолучитьФункциональнуюОпциюСервер(Имя) Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию(Имя);
	
КонецФункции

// Возвращает значение функциональной опции по имени. Для использования на клиенте.
Функция ПолучитьКонстантуСервер(Имя) Экспорт
	
	Возврат Константы[Имя].Получить();
	
КонецФункции

// Возвращает структуру, содержащую значения реквизитов, прочитанные из информационной базы по ссылке на объект.
// Рекомендуется использовать вместо обращения к реквизитам объекта через точку от ссылки на объект
// для быстрого чтения отдельных реквизитов объекта из базы данных.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//            - Строка      - полное имя предопределенного элемента, значения реквизитов которого необходимо получить.
//  Реквизиты - Строка - имена реквизитов, перечисленные через запятую, в формате
//                       требований к свойствам структуры.
//                       Например, "Код, Наименование, Родитель".
//            - Структура, ФиксированнаяСтруктура - в качестве ключа передается
//                       псевдоним поля для возвращаемой структуры с результатом, а в качестве
//                       значения (опционально) фактическое имя поля в таблице.
//                       Если ключ задан, а значение не определено, то имя поля берется из ключа.
//            - Массив, ФиксированныйМассив - имена реквизитов в формате требований
//                       к свойствам структуры.
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объекту выполняется с учетом прав пользователя;
//                                если есть ограничение на уровне записей, то все реквизиты вернутся со 
//                                значением Неопределено; если нет прав для работы с таблицей, то возникнет исключение;
//                                если Ложь, то возникнет исключение при отсутствии прав на таблицу 
//                                или любой из реквизитов.
//
// Возвращаемое значение:
//  Структура - содержит имена (ключи) и значения затребованных реквизитов.
//            - если в параметр Реквизиты передана пустая строка, то возвращается пустая структура.
//            - если в параметр Ссылка передана пустая ссылка, то возвращается структура, 
//              соответствующая именам реквизитов со значениями Неопределено.
//            - если в параметр Ссылка передана ссылка несуществующего объекта (битая ссылка), 
//              то все реквизиты вернутся со значением Неопределено.
//
Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты, ВыбратьРазрешенные = Ложь) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты, ВыбратьРазрешенные);
	
КонецФункции

// Возвращает значение реквизита, прочитанного из информационной базы по ссылке на объект.
// 
//  Если доступа к реквизиту нет, возникнет исключение прав доступа.
//  Если необходимо зачитать реквизит независимо от прав текущего пользователя,
//  то следует использовать предварительный переход в привилегированный режим.
// 
// Параметры:
//  Ссылка       - ссылка на объект, - элемент справочника, документ, ...
//  ИмяРеквизита - Строка, например, "Код".
// 
// Возвращаемое значение:
//  Произвольный    - зависит от типа значения прочитанного реквизита.
// 
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

// Возвращает значение счетчика открытия формы оценки мобильного клиента текущего устройства.
//
Функция ПолучитьСчетчикДляОткрытияФормыОценкиМобильногоКлиента() Экспорт
	
	Возврат РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.ПолучитьЗначение();
	
КонецФункции

// Устанавливает значение счетчика открытия формы оценки мобильного клиента.
//
Процедура УстановитьСчетчикДляОткрытияФормыОценкиМобильногоКлиента(ЗначениеСчетчика) Экспорт
	
	РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.УстановитьЗначение(ЗначениеСчетчика);
	
КонецПроцедуры

// Увеличивает значение счетчика запусков клиента.
//
Процедура УвеличитьСчетчикЗапусковКлиента(ЭтоМобильныйКлиент) Экспорт
	
	РегистрыСведений.СчетчикЗапусковКлиента.УвеличитьСчетчик(ЭтоМобильныйКлиент);
	
КонецПроцедуры

// Получает значения счетчика запусков клиента.
//
Функция ПолучитьЗначенияСчетчикаЗапусковКлиента() Экспорт
	
	Возврат РегистрыСведений.СчетчикЗапусковКлиента.ПолучитьЗначенияСчетчика();
	
КонецФункции

// УстанавливаетЗапретОткрытияФормыОпроса.
//
Процедура УстановитьЗапретОткрытияФормыОпроса(ЗапретОткрытияОпроса) Экспорт
	
	РегистрыСведений.СчетчикЗапусковКлиента.УстановитьЗапретОткрытияФормыОпроса(ЗапретОткрытияОпроса);
	
КонецПроцедуры

Функция ПолучитьПараметрыРегистрацииККТ(ККТ) Экспорт
	
	Возврат УправлениеНебольшойФирмойСервер.ПолучитьПараметрыРегистрацииККТ(ККТ);
	
КонецФункции

// Возвращает служебную информацию для письма о новых возможностях
//
Функция СлужебнаяИнформацияДляПисьма(Тег) Экспорт
	
	Возврат Обработки.НастройкаПрограммы.СлужебнаяИнформацияДляПисьма(Тег);
	
КонецФункции

#КонецОбласти
