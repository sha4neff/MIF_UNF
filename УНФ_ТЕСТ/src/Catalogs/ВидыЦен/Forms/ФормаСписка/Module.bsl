
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьРезультатВыполненияФоновогоЗадания(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗагрузки = Неопределено Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки = РезультатЗагрузки;
	
	Заголовок = НСтр("ru ='Загрузка цен'");
	Если КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки.Статус = "Выполнено" Тогда 
		
		ТекстОповещения = НСтр("ru ='Цены номенклатуры.
			|Загрузка данных завершена.'");
		
		ПоказатьОповещениеПользователя(ТекстОповещения, , Заголовок);
		
	ИначеЕсли КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки.Статус = "Ошибка" Тогда
		
		ПоказатьОповещениеПользователя(РезультатЗагрузки.КраткоеПредставлениеОшибки, , Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбработкиПодготовленныхДанных()
	
	Если КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки = Неопределено Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	Если КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки.Статус <> "Выполняется" Тогда 
		
		ОбработатьРезультатВыполненияФоновогоЗадания(КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки, Неопределено);
		Возврат;
		
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбработатьРезультатВыполненияФоновогоЗадания", ЭтотОбъект, Неопределено);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения				= НСтр("ru ='Загрузка цен из внешнего источника'");
	ПараметрыОжидания.ВыводитьОкноОжидания			= Истина;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения	= Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки, Обработчик, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЦены(ВидЦен)
	Перем ОписаниеОшибки;
	
	Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДанныеВидаЦен = ПолучитьДанныеВидаЦен(ВидЦен);
	Если ДанныеВидаЦен.ТипВидаЦен = КэшЗначений.Статический Тогда
		
		МассивВидовЦен = Новый Массив;
		МассивВидовЦен.Добавить(ВидЦен);
		
		ПараметрыОткрытия = Новый Структура("ВидыЦен", МассивВидовЦен);
		ОткрытьФорму("Обработка.ФормированиеЦенНоменклатуры.Форма", ПараметрыОткрытия, ЭтаФорма);
		
	ИначеЕсли НЕ ДанныеВидаЦен.РассчитыватьАвтоматически Тогда
		
		Если ДанныеВидаЦен.ЦеныАктуальны Тогда
			
			ТекстСообщения = НСтр("ru ='Цены по колонке прайс-листа актуальны. Расчет не требуется.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, ВидЦен, "Список");
			
		Иначе
			
			ПараметрыОткрытия = Новый Структура("ВидЦен", ВидЦен);
			ОткрытьФорму("Обработка.ФормированиеЦенНоменклатуры.Форма.РасчетныеЦены", ПараметрыОткрытия, ЭтаФорма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура сохраняет выбранный элемент в настройки
//
Процедура УстановитьОсновнойЭлемент(ВыбранныйЭлемент)
	
	Если ВыбранныйЭлемент <> УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойВидЦенПродажи") Тогда
		УправлениеНебольшойФирмойСервер.УстановитьНастройкуПользователя(ВыбранныйЭлемент, "ОсновнойВидЦенПродажи");	
		УправлениеНебольшойФирмойСервер.ВыделитьЖирнымОсновнойЭлемент(ВыбранныйЭлемент, Список);
	КонецЕсли; 
		
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеВидаЦен(ВидЦен)
	
	ДанныеВидаЦен = Новый Структура;
	ДанныеВидаЦен.Вставить("ВыбранныйВидЦен",			ВидЦен);
	ДанныеВидаЦен.Вставить("ТипВидаЦен",				ВидЦен.ТипВидаЦен);
	ДанныеВидаЦен.Вставить("РассчитыватьАвтоматически", ВидЦен.РассчитыватьАвтоматически);
	ДанныеВидаЦен.Вставить("ЦеныАктуальны",				ВидЦен.ЦеныАктуальны);
	
	Возврат ДанныеВидаЦен;
	
КонецФункции

&НаСервере
Процедура ИндикаторКоличестваЦен()
	
	КоличествоЗаписейMax = 500000;
	КоличествоЗаписейMedium = 200000;
	
	Запрос = Новый Запрос("ВЫБРАТЬ Количество(1) КАК КоличествоЗаписей ИЗ РегистрСведений.ЦеныНоменклатуры");
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Если Выборка.КоличествоЗаписей > КоличествоЗаписейMax Тогда
			
			МассивФорматированныхСтрок = Новый Массив(3);
			МассивФорматированныхСтрок[0] = Новый ФорматированнаяСтрока(НСтр("ru ='Рекомендуем воспользоваться'"));
			МассивФорматированныхСтрок[1] = Новый ФорматированнаяСтрока(НСтр("ru =' очисткой цен номенклатуры'"), , , , "очистка");
			МассивФорматированныхСтрок[2] = Новый ФорматированнаяСтрока(НСтр("ru ='для ускорения работы.'"));
			
			Элементы.ДекорацияКартинкаКоличестваЦенРасширеннаяПодсказка.Заголовок = Новый ФорматированнаяСтрока(МассивФорматированныхСтрок);
			Элементы.ДекорацияКартинкаКоличестваЦен.Картинка = БиблиотекаКартинок.УдалениеУстаревшихЦенMax;
			
		ИначеЕсли Выборка.КоличествоЗаписей > КоличествоЗаписейMedium Тогда
		
			Элементы.ДекорацияКартинкаКоличестваЦенРасширеннаяПодсказка.Заголовок = НСтр("ru ='Medium количество цен. Очистка для ускорения работы не требуется.'");
			Элементы.ДекорацияКартинкаКоличестваЦен.Картинка = БиблиотекаКартинок.УдалениеУстаревшихЦенMedium;
			
		Иначе
			
			Элементы.ДекорацияКартинкаКоличестваЦенРасширеннаяПодсказка.Заголовок = НСтр("ru ='Min количество цен. Очистка для ускорения работы не требуется.'");
			Элементы.ДекорацияКартинкаКоличестваЦен.Картинка = БиблиотекаКартинок.УдалениеУстаревшихЦенMin;
			
		КонецЕсли;
		
	Иначе
		
		Элементы.ГруппаОчисткаЦен.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#Область БыстрыйОтбор

&НаСервере
Процедура ПрочитатьПрайсЛисты()
	
	Запрос = Новый Запрос("ВЫБРАТЬ ЛОЖЬ КАК Флаг, ПЛ.Ссылка КАК ПрайсЛист ИЗ Справочник.ПрайсЛисты КАК ПЛ ГДЕ НЕ ПЛ.ПометкаУдаления");
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Элементы.ОтборПрайсЛисты.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСверху;
		
	Иначе
		
		ЗначениеВРеквизитФормы(РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией), "ОтборПрайсЛисты");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПрайсЛистыФлагПриИзменении(Элемент)
	
	ТекущаяСтрокаДерева = ОтборПрайсЛисты.НайтиПоИдентификатору(Элементы.ОтборПрайсЛисты.ТекущиеДанные.ПолучитьИдентификатор());
	УстановитьФлагУПодчиненных(ТекущаяСтрокаДерева.ПолучитьЭлементы(), ТекущаяСтрокаДерева.Флаг);
	
	ПрайсЛисты	= НайтиВыбранныеСтроки(ОтборПрайсЛисты.ПолучитьЭлементы());
	ВидыЦен		= ВидыЦенПрайсЛистов(ПрайсЛисты);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", ВидыЦен, ВидСравненияКомпоновкиДанных.ВСписке, , (ВидыЦен.Количество() > 0));
	
	#Если МобильныйКлиент Тогда
		
		ТекстЗаголовка = СтрШаблон(НСтр("ru ='Фильтр по прайс-листам %1'"), ?(ВидыЦен.Количество() > 0, НСтр("ru =' (установлен)'"), ""));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФильтрыНастройкиИДопИнфо", "Заголовок", ТекстЗаголовка);
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФлагУПодчиненных(СписокЭлементов, Флаг)
	
	Для Каждого СтрокаДерева Из СписокЭлементов Цикл
		
		СтрокаДерева.Флаг = Флаг;
		
		ДочерниеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если ДочерниеСтроки.Количество() > 0 Тогда
			
			УстановитьФлагУПодчиненных(ДочерниеСтроки, Флаг);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция НайтиВыбранныеСтроки(СписокЭлементов)
	
	ПрайсЛисты = Новый Массив;
	Для Каждого СтрокаДерева Из СписокЭлементов Цикл
		
		Если СтрокаДерева.Флаг Тогда
			
			ПрайсЛисты.Добавить(СтрокаДерева.ПрайсЛист);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПрайсЛисты;
	
КонецФункции

&НаСервере
Функция ВидыЦенПрайсЛистов(ПрайсЛисты)
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ ВидыЦен.ВидЦен КАК ВидЦен ИЗ Справочник.ПрайсЛисты.ВидыЦен КАК ВидыЦен ГДЕ ВидыЦен.Ссылка В(&ПрайсЛисты)");
	Запрос.УстановитьПараметр("ПрайсЛисты", ПрайсЛисты);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидЦен");
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СобытияФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.РазрешеноРедактированиеЦенДокументов();
	
	Элементы.Список.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	Элементы.СформироватьЦены.Видимость = РазрешеноРедактированиеЦенДокументов;
	
	// Выделение основного элемента	
	УправлениеНебольшойФирмойСервер.ВыделитьЖирнымОсновнойЭлемент(УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойВидЦенПродажи"), Список);
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("Статический",			Перечисления.ТипыВидовЦен.Статический);
	КэшЗначений.Вставить("ДинамическийПроцент", Перечисления.ТипыВидовЦен.ДинамическийПроцент);
	КэшЗначений.Вставить("ДинамическийФормула", Перечисления.ТипыВидовЦен.ДинамическийФормула);
	КэшЗначений.Вставить("ЭтоЗагрузкаИзВнешнегоИсточника", Неопределено);
	КэшЗначений.Вставить("ПараметрыДлительнойОперации", Новый Структура);
	КэшЗначений.ПараметрыДлительнойОперации.Вставить("РезультатЗагрузки",	Неопределено);
	КэшЗначений.ПараметрыДлительнойОперации.Вставить("ИдентификаторЗадания","");
	
	Параметры.Свойство("ЭтоЗагрузкаИзВнешнегоИсточника", КэшЗначений.ЭтоЗагрузкаИзВнешнегоИсточника);
	
	ПрочитатьПрайсЛисты();
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		
		ИндикаторКоличестваЦен();
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОчисткаЦен", "Видимость", Ложь);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере(Метаданные.РегистрыСведений.ЦеныНоменклатуры, НастройкиЗагрузкиДанных, ЭтотОбъект, Ложь);
	// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	
	#Если МобильныйКлиент Тогда
		
		Элементы.ОтборПрайсЛистыФлаг.Вид = ВидПоляФормы.ПолеНадписи;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтборПрайсЛистыФлаг", "Формат", "БЛ=пропустить; БИ=расчитывается");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Группа1", "Группировка", ГруппировкаКолонок.Горизонтальная);
		
	#КонецЕсли
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если КэшЗначений.ЭтоЗагрузкаИзВнешнегоИсточника = Истина Тогда
		
		ПодключитьОбработчикОжидания("ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ОбработкаОповещения
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьРасчетныхЦен" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СозданиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СформироватьЦены Тогда
		
		СтандартнаяОбработка = Ложь;
		СформироватьЦены(ВыбраннаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ДанныеТекущейстроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеТекущейстроки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияПредупреждение", "Видимость", ДанныеТекущейстроки.ПоказатьПредупреждение);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПрайсЛистыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	#Если МобильныйКлиент Тогда
		
		СтандартнаяОбработка = Ложь;
		
	#Иначе
		
		СтандартнаяОбработка = Истина;
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПрайсЛистыПриАктивизацииСтроки(Элемент)
	
	#Если НЕ МобильныйКлиент Тогда
		
		Возврат;
		
	#КонецЕсли
	
	ДанныеТекущейСтроки = Элементы.ОтборПрайсЛисты.ТекущиеДанные;
	Если ДанныеТекущейСтроки = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДанныеТекущейСтроки.Флаг = НЕ ДанныеТекущейСтроки.Флаг;
	ОтборПрайсЛистыФлагПриИзменении(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура - обработчик выполнения команды УстановитьОсновнойЭлемент
//
Процедура КомандаУстановитьОсновнойЭлемент(Команда)
		
	ВыбранныйЭлемент = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
		УстановитьОсновнойЭлемент(ВыбранныйЭлемент);	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКартинкаКоличестваЦенНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеУдалениеУстаревшихЦен", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.УдалениеУстаревшихЦен.Форма", Неопределено, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКартинкаКоличестваЦенРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеУдалениеУстаревшихЦен", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.УдалениеУстаревшихЦен.Форма", Неопределено, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдалениеУстаревшихЦен(Результат, ДополнительныеПараметры) Экспорт
	
	ИндикаторКоличестваЦен();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла
&НаКлиенте
Процедура ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника()
	
	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	Если ЗначениеЗаполнено(ДанныеТекущейСтроки.Ссылка) Тогда
		
		НастройкиЗагрузкиДанных.Вставить("ОбщееЗначение", ДанныеТекущейСтроки.Ссылка);
		
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
	
	ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЦеныИзВнешнегоИсточника(Команда)
	
	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено
		И ДанныеТекущейСтроки.ТипВидаЦен <> КэшЗначений.Статический Тогда
		
		ТекстСообщения = НСтр("ru ='Загрузка предназначена только для статических видов цен.'");
		ПоказатьПредупреждение(Неопределено, ТекстСообщения, 15, НСтр("ru ='Загрузить цены из внешнего источника'"));
		Возврат;
		
	КонецЕсли;
	
	ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗагрузки) = Тип("Структура") Тогда
		
		Если РезультатЗагрузки.ОписаниеДействия = "ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника" Тогда
		
			ЗагрузкаДанныхИзВнешнегоИсточника.ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
			ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
			
		ИначеЕсли РезультатЗагрузки.ОписаниеДействия = "ОбработатьПодготовленныеДанные" Тогда
			
			ОбработатьПодготовленныеДанные(РезультатЗагрузки);
			ПослеОбработкиПодготовленныхДанных();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодготовленныеДанные(РезультатЗагрузки)
	
	Если ЗначениеЗаполнено(КэшЗначений.ПараметрыДлительнойОперации.ИдентификаторЗадания) Тогда
		
		ДлительныеОперации.ОтменитьВыполнениеЗадания(КэшЗначений.ПараметрыДлительнойОперации.ИдентификаторЗадания);
		КэшЗначений.ПараметрыДлительнойОперации.ИдентификаторЗадания = Неопределено;
		
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("НастройкиЗагрузкиДанных", РезультатЗагрузки.НастройкиЗагрузкиДанных);
	ПараметрыПроцедуры.Вставить("ТаблицаСопоставленияДанных", ДанныеФормыВЗначение(РезультатЗагрузки.ТаблицаСопоставленияДанных, Тип("ТаблицаЗначений")));
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка цен из внешнего источника'");
	ПараметрыВыполнения.ЗапуститьВФоне				= Истина;
	
	ИмяМетода = "РегистрыСведений.ЦеныНоменклатуры.ОбработатьПодготовленныеДанные";
	РезультатФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыПроцедуры, ПараметрыВыполнения);
	
	КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки		= РезультатФоновогоЗадания;
	КэшЗначений.ПараметрыДлительнойОперации.ИдентификаторЗадания	= РезультатФоновогоЗадания.ИдентификаторЗадания;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

#КонецОбласти