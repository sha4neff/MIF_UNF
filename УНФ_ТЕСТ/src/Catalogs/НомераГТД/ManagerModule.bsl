#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ЗагрузкаДанныхИзВнешнегоИсточника

Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	//
	// Для группы полей действует правило: хотя бы одно поле в группе должно быть выбрано в колонках
	//
	
	ОписаниеТиповСтрока3 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(3));
	ОписаниеТиповСтрока7 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(7));
	ОписаниеТиповСтрока8 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(8));
	ОписаниеТиповСтрока11 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(11));
	ОписаниеТиповСтрока25 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(25));
	ОписаниеТиповСтрока40 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(40));
	ОписаниеТиповСтрока30 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(30));
	ОписаниеТиповСтрока0000 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(0));
	ОписаниеТиповДата = Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	ОписаниеТиповБулево = Новый ОписаниеТипов("Булево");
	
	Если НастройкиЗагрузкиДанных.ФиксированныйШаблон Тогда
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "УИД", "УИД", ОписаниеТиповСтрока40, ОписаниеТиповСтрока40);
	КонецЕсли;
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Код", "Номер ГТД", ОписаниеТиповСтрока30, ОписаниеТиповСтрока30);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "РегистрационныйНомер", "Регистрационный номер", ОписаниеТиповСтрока30, ОписаниеТиповСтрока30);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Описание", "Описание", ОписаниеТиповСтрока0000, ОписаниеТиповСтрока0000);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ДатаПринятия", "Дата принятия", ОписаниеТиповСтрока25, ОписаниеТиповДата);	
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ДопускаетсяЗаписьСОшибкой", "Допускается запись с ошибкой", ОписаниеТиповСтрока11, ОписаниеТиповБулево);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "КодТаможенногоОргана", "Код таможенного органа", ОписаниеТиповСтрока8, ОписаниеТиповСтрока8);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "НомерРазделаИлиТовара", "НомерРазделаИлиТовара", ОписаниеТиповСтрока3, ОписаниеТиповСтрока3);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ПорядковыйНомер", "Порядковый номер", ОписаниеТиповСтрока7, ОписаниеТиповСтрока7);
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ПараметрыСопоставления, АдресРезультата = Неопределено) Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицы Из ТаблицаСопоставленияДанных Цикл
		
			
		СтрокаТаблицы.НомерГТД = ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ЗаполнитьПоУИД(СтрокаТаблицы, "НомераГТД", "УИД_ВходящиеДанные");
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НомерГТД) Тогда
			
			// НомерГТД по Наименованию
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНомерГТД(СтрокаТаблицы.НомерГТД, СтрокаТаблицы.Код_ВходящиеДанные);
			
		КонецЕсли; 
		
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВДату(СтрокаТаблицы.ДатаПринятия, СтрокаТаблицы.ДатаПринятия_ВходящиеДанные);
		
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВБулево(СтрокаТаблицы.ДопускаетсяЗаписьСОшибкой, СтрокаТаблицы.ДопускаетсяЗаписьСОшибкой_ВходящиеДанные);
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицы);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицы), РазмерТаблицыДанных);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	СтрокаТаблицы._СтрокаСопоставлена = ЗначениеЗаполнено(СтрокаТаблицы.НомерГТД);
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	СтрокаТаблицы[ИмяСлужебногоПоля] = СтрокаТаблицы._СтрокаСопоставлена
		ИЛИ (НЕ СтрокаТаблицы._СтрокаСопоставлена И НЕ ПустаяСтрока(СтрокаТаблицы.Код_ВходящиеДанные));
	
КонецПроцедуры

Процедура ОбработатьПодготовленныеДанные(РезультатЗагрузки) Экспорт
	
	НастройкиЗагрузкиДанных = РезультатЗагрузки.НастройкиЗагрузкиДанных;
	НастройкиОбновленияСвойств = НастройкиЗагрузкиДанных.НастройкиОбновленияСвойств;
	
	Для каждого СтрокаТаблицы Из РезультатЗагрузки.ТаблицаСопоставленияДанных Цикл
		
		ЗагрузкаВПриложениеВозможна = СтрокаТаблицы[ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна()];
		
		СогласованноеСостояниеСтроки = (СтрокаТаблицы._СтрокаСопоставлена И РезультатЗагрузки.НастройкиЗагрузкиДанных.ОбновлятьСуществующие)
			ИЛИ (НЕ СтрокаТаблицы._СтрокаСопоставлена И РезультатЗагрузки.НастройкиЗагрузкиДанных.СоздаватьЕслиНеСопоставлено);
		
		Если ЗагрузкаВПриложениеВозможна И СогласованноеСостояниеСтроки Тогда
			
			Если СтрокаТаблицы._СтрокаСопоставлена Тогда
				
				ЭлементСправочника = СтрокаТаблицы.НомерГТД.ПолучитьОбъект();
				ЭлементСправочника.Заблокировать();
			Иначе
				
				ЭлементСправочника = Справочники.НомераГТД.СоздатьЭлемент();
				
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, "УИД") И ЗначениеЗаполнено(СтрокаТаблицы.УИД) Тогда
					НовыйУИД = Новый УникальныйИдентификатор(СтрокаТаблицы.УИД);
					ЭлементСправочника.УстановитьСсылкуНового(Справочники.НомераГТД.ПолучитьСсылку(НовыйУИД));
				КонецЕсли;
				
				ЭлементСправочника.ДопускаетсяЗаписьСОшибкой = Истина;
				
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ЭлементСправочника, СтрокаТаблицы, НастройкиОбновленияСвойств.ИменаПолейОбновляемые);
			
			ЭлементСправочника.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Служебные

Функция ПроверитьКорректностьЗаполненияНомераГТД(СсылкаИлиСтруктура) Экспорт
	Перем Ошибки;
	
	Если СтрДлина(СсылкаИлиСтруктура.КодТаможенногоОргана) <> 2
		И СтрДлина(СсылкаИлиСтруктура.КодТаможенногоОргана) <> 5
		И СтрДлина(СсылкаИлиСтруктура.КодТаможенногоОргана) <> 8 Тогда
		
		ТекстОшибки = НСтр("ru ='Код таможенного органа (первая секция номера) имеет ошибочную длину (допускается 2, 5, 8 символов)'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Код", ТекстОшибки, "");
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СсылкаИлиСтруктура.ДатаПринятия) Тогда
		
		ТекстОшибки = НСтр("ru ='Пустая дата принятия декларации (вторая секция номера)'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Код", ТекстОшибки, "");
		
	КонецЕсли;
	
	Если СтрДлина(СсылкаИлиСтруктура.ПорядковыйНомер) <> 7 Тогда
		
		ТекстОшибки = НСтр("ru ='Порядковый номер (третья секция номера) имеет ошибочную длину (допускается только 7 символов)'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Код", ТекстОшибки, "");
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СсылкаИлиСтруктура.НомерРазделаИлиТовара)
		И СтрДлина(СсылкаИлиСтруктура.НомерРазделаИлиТовара) > 3 Тогда
		
		ТекстОшибки = НСтр("ru ='Номер раздела/товара (четвертая секция номера) имеет ошибочную длину (допускается только от 1 до 3 символов)'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Код", ТекстОшибки, "");
		
	КонецЕсли;
	
	Возврат Ошибки;
	
КонецФункции

Функция ДанныеНомераГТД(КодСтрокой, РазделительДекларации = "/") Экспорт
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("КодТаможенногоОргана",	"");
	СтруктураДанных.Вставить("ДатаПринятия",			Дата(1, 1, 1));
	СтруктураДанных.Вставить("ПорядковыйНомер",			"");
	СтруктураДанных.Вставить("НомерРазделаИлиТовара",	"");
	СтруктураДанных.Вставить("РегистрационныйНомер",	"");
	
	МассивСекцийГТД = СтрРазделить(КодСтрокой, РазделительДекларации);
	Если МассивСекцийГТД.Количество() < 3
		ИЛИ МассивСекцийГТД.Количество() > 4 Тогда
		
		СтруктураДанных.Вставить("РегистрационныйНомер", КодСтрокой);
		
	Иначе
		
		СтруктураДанных.КодТаможенногоОргана= СокрЛП(МассивСекцийГТД[0]);
		ДатаПринятияСтрокой					= СокрЛП(МассивСекцийГТД[1]);
		СтруктураДанных.ПорядковыйНомер		= СокрЛП(МассивСекцийГТД[2]);
		
		Если СтрДлина(ДатаПринятияСтрокой) = 6
			И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ДатаПринятияСтрокой) Тогда
			
			СтруктураДанных.ДатаПринятия = СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаПринятияСтрокой);
			
		КонецЕсли;
		
		СтруктураДанных.РегистрационныйНомер = СтруктураДанных.КодТаможенногоОргана + РазделительДекларации + ДатаПринятияСтрокой + РазделительДекларации + СтруктураДанных.ПорядковыйНомер;
		
		Если МассивСекцийГТД.Количество() = 4 Тогда
			
			СтруктураДанных.НомерРазделаИлиТовара = СокрЛП(МассивСекцийГТД[3]);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции

#КонецОбласти

#Область ИнтерфейсПечати

// Функция возвращает массив номеров ГТД, которые использовались для указаной номенклатуры
// Если номенклатура не указана. возращается пустой массив.
//
// Параметры:
//	УсловияОтбора - Структура	- Содержит поля отборов.
//	Описание:
//	* Организация (Справочники.Организации) - если не заполнено, выборка происходит по всем организациям;
//	* Номенклатура (Справочники.Номенклатура) - если не заполнено, возращается пустой массив;
//	* Характеристика (Справочники.ХарактеристикиНоменклатуры) - если не заполнено, выбираем все характеристики;
//	* Партия (Справочники.ПартииНоменклатуры) - если не заполнено, выбираем все партии;
//	* СтранаПроисхожденния (Справочники.СтраныМира) - если не заполнено, выбираем по любой стране;
//
Функция ПолучитьМассивИспользуемыхНомеровГТД(УсловияОтбора) Экспорт
	
	Если НЕ (УсловияОтбора.Свойство("Номенклатура")
		И ЗначениеЗаполнено(УсловияОтбора.Номенклатура)) Тогда
		
		Возврат Новый Массив;
		
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ РегистрГТД.НомерГТД КАК НомерГТД ИЗ РегистрНакопления.ЗапасыВРазрезеГТД КАК РегистрГТД ГДЕ 
	|&УсловиеОрганизации
	|И РегистрГТД.Номенклатура = &Номенклатура
	|И &УсловиеХарактеристики
	|И &УсловиеПартии
	|И &УсловиеСтраныПроисхождения");
	
	Запрос.УстановитьПараметр("Номенклатура", УсловияОтбора.Номенклатура);
		
	Если УсловияОтбора.Свойство("Организация")
		И ЗначениеЗаполнено(УсловияОтбора.Организация) Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОрганизации", "РегистрГТД.Организация = &Организация");
		Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(УсловияОтбора.Организация));
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОрганизации", "Истина");
		
	КонецЕсли;
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики")
		И УсловияОтбора.Свойство("Характеристика") Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеХарактеристики", "РегистрГТД.Характеристика = &Характеристика");
		Запрос.УстановитьПараметр("Характеристика", УсловияОтбора.Характеристика);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеХарактеристики", "Истина");
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартии")
		И УсловияОтбора.Свойство("Партия") Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПартии", "РегистрГТД.Партия = &Партия");
		Запрос.УстановитьПараметр("Партия", УсловияОтбора.Партия);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПартии", "Истина");
		
	КонецЕсли;
		
	Если УсловияОтбора.Свойство("СтранаПроисхождения")
		И ЗначениеЗаполнено(УсловияОтбора.СтранаПроисхождения) Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСтраныПроисхождения", "РегистрГТД.СтранаПроисхождения = &СтранаПроисхождения");
		Запрос.УстановитьПараметр("СтранаПроисхождения", УсловияОтбора.СтранаПроисхождения);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСтраныПроисхождения", "Истина");
		
	КонецЕсли;
	
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат ТаблицаРезультатаЗапроса.ВыгрузитьКолонку("НомерГТД");
	
КонецФункции // ПолучитьМассивИспользуемыхНомеровГТД()

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли