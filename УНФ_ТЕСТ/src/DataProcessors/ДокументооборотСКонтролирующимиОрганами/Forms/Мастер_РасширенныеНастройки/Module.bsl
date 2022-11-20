&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПараметры(Параметры);
	ИзменитьОформлениеФормы();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерОсновнойПоставки1сПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура НомерОсновнойПоставки1сОчистка(Элемент, СтандартнаяОбработка)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ТелефонОсновнойПриИзменении(Элемент)
	ИзменитьОформлениеФормы();
	Модифицированность = Истина;
	ТелефонОсновной_ПриИзмененииТекстаРедактирования(Элемент.ТекстРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ТелефонОсновнойИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ТелефонОсновной_ПриИзмененииТекстаРедактирования(Текст);
		
КонецПроцедуры

&НаКлиенте
Процедура ВладелецЭЦПДолжностьПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ВладелецЭЦППодразделениеПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиОшибку(Элемент)
	
	Если Элемент.Подсказка <> "" Тогда
		ПоказатьПредупреждение(,Элемент.Подсказка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЮридическийАдресПоФактическомуНажатие(Элемент)
	
	АдресЮридическийЗначение = АдресФактическийЗначение;
	АдресЮридическийПредставление = АдресФактическийПредставление;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФактическийАдресПоЮридическомуНажатие(Элемент)
	
	АдресФактическийЗначение = АдресЮридическийЗначение;
	АдресФактическийПредставление = АдресЮридическийПредставление;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЮридическийПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"АдресЮридическийПредставлениеНажатие_Завершение", 
		ЭтотОбъект, 
		Элемент);
		
	ДополнительныеПараметры = КонтекстЭДОКлиент.ПараметрыПроцедурыРедактироватьАдрес();
	ДополнительныеПараметры.Вставить("Адрес",             АдресЮридическийЗначение);
	ДополнительныеПараметры.Вставить("АдресИмя",          Элемент.Имя);
	ДополнительныеПараметры.Вставить("Элемент",           Элемент);
	ДополнительныеПараметры.Вставить("Оповещение",        ОписаниеОповещения);
	ДополнительныеПараметры.Вставить("ПринудительноФИАС", Истина);
	ДополнительныеПараметры.Вставить("ТолькоПросмотр",    ЗапретитьИзменение);
		
	КонтекстЭДОКлиент.РедактироватьАдрес(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФактическийПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"АдресФактическийПредставлениеНажатие_Завершение", 
		ЭтотОбъект, 
		Элемент);
		
	ДополнительныеПараметры = КонтекстЭДОКлиент.ПараметрыПроцедурыРедактироватьАдрес();
	ДополнительныеПараметры.Вставить("Адрес",             АдресФактическийЗначение);
	ДополнительныеПараметры.Вставить("АдресИмя",          Элемент.Имя);
	ДополнительныеПараметры.Вставить("Элемент",           Элемент);
	ДополнительныеПараметры.Вставить("Оповещение",        ОписаниеОповещения);
	ДополнительныеПараметры.Вставить("ПринудительноФИАС", Истина);
	ДополнительныеПараметры.Вставить("ТолькоПросмотр",    ЗапретитьИзменение);
	
	КонтекстЭДОКлиент.РедактироватьАдрес(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьСМСПриИзменении(Элемент)
	Модифицированность = Истина;
	УстановитьДоступностьМобильногоТелефона(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТелефонМобильныйПриИзменении(Элемент)
	
	ИзменитьОформлениеФормы();
	Модифицированность = Истина;
	ТелефонМобильныйИзменился = Истина;
	ТелефонМобильный_ПриИзмененииТекстаРедактирования(Элемент.ТекстРедактирования, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонМобильныйИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ТелефонМобильныйИзменился = Истина;
	ТелефонМобильный_ПриИзмененииТекстаРедактирования(Текст, Истина);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда = Неопределено)
	
	ДанныеКорректны = Истина;
	РеквизитыУказаныКорректно(ДанныеКорректны, Истина);
	
	Если ДанныеКорректны Тогда
		
		// Если нет ЭП в облаке, то телефон один, поэтому не спрашиваем
		СпроситьПроИзменениеТелефона = ТелефонМобильныйИзменился И РежимРаботыСКлючами = 1
			И НЕ КонтекстЭДОКлиент.ТелефоныСовпадают(ТелефонДляПаролей, ТелефонМобильный);
		
		Если СпроситьПроИзменениеТелефона Тогда
			СпроситьПроИзменениеТелефона();
		Иначе
			ЗакрытьПослеПроверки();
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СпроситьПроИзменениеТелефона()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбновитьТелефонДляПаролейПоТелефонуМобильному_Завершение", 
		ЭтотОбъект);
				
	ТекстВопроса = НСтр("ru = 'Вы изменили номер мобильного телефона для SMS-уведомлений о статусе отправки отчетов и входящих сообщениях.
                         |Изменить также номер мобильного телефона, на который высылаются пароли для отправки отчетности?'");
		
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОбновитьТелефонДляПаролейПоТелефонуМобильному_Завершение(Ответ, ВходящийКонтекст) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ТелефонДляПаролей = ТелефонМобильный;
	КонецЕсли;
	
	ЗакрытьПослеПроверки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьПослеПроверки()
	
	ДополнительныеПараметры = Новый Структура(ПараметрыФормы);
	ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, ЭтотОбъект, ПараметрыФормы); 
	ДополнительныеПараметры.Вставить("ПараметрыФормы", 		ПараметрыФормы);
	ДополнительныеПараметры.Вставить("Модифицированность", 	Модифицированность);
	
	Модифицированность = Ложь;
	
	Закрыть(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонМобильный_ПриИзмененииТекстаРедактирования(Текст, ИзмененоВручную = Ложь)
	
	Если ИзмененоВручную Тогда
		Пауза = 1.5;
	Иначе
		Пауза = 0.1;
	КонецЕсли;
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Текст);
	
	// Обновляем фактичекое значение
	Если ЗначениеЗаполнено(Представление) Тогда
		// Устанавливаем телефон в виде +7 ХХХ ХХХ-ХХ-ХХ
		ТелефонМобильный = Представление;
	Иначе
		// В противном случае, устанавливаем то, что ввел пользователь
		ТелефонМобильный = Текст;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьТелефонМобильный");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТелефонМобильный", Пауза, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьТелефонМобильный()
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(ТелефонМобильный);
	
	// Меняем отображение на форме
	Если ЗначениеЗаполнено(Представление) Тогда
		Элементы.ТелефонМобильный.ОбновитьТекстРедактирования();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонОсновной_ПриИзмененииТекстаРедактирования(Текст, Пауза = 1.5)
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Текст);
	
	// Обновляем фактичекое значение
	Если ЗначениеЗаполнено(Представление) Тогда
		// Устанавливаем телефон в виде +7 ХХХ ХХХ-ХХ-ХХ
		ТелефонОсновной = Представление;
	Иначе
		// В противном случае, устанавливаем то, что ввел пользователь
		ТелефонОсновной = Текст;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьТелефонОсновной");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТелефонОсновной", Пауза, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьТелефонОсновной()
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(ТелефонОсновной);
	
	// Меняем отображение на форме
	Если ЗначениеЗаполнено(Представление) Тогда
		Элементы.ТелефонОсновной.ОбновитьТекстРедактирования();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РеквизитыУказаныКорректно(МастерДалее = Истина, ВыводитьСообщения = Истина)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.РасширенныеНастройкиУказаныКорректно(ЭтотОбъект, МастерДалее, ВыводитьСообщения, Истина);
	
КонецФункции

&НаКлиенте
Процедура АдресЮридическийПредставлениеНажатие_Завершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	НовыйАдрес = КонтекстЭДОКлиент.РедактироватьАдресКонвертацияРезультата(РезультатЗакрытия, Истина);
	
	Если НовыйАдрес.Модифицированность Тогда
		
		Модифицированность = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"АдресЮридическийПредставлениеНажатие_ПослеОбновления", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
		
		КонтекстЭДОКлиент.ОбновитьАдрес(НовыйАдрес, "АдресЮридический", ОписаниеОповещения, ЭтоЮридическоеЛицо);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЮридическийПредставлениеНажатие_ПослеОбновления(Результат, ВходящийКонтекст) Экспорт
	
	ИнициализироватьФактическийАдрес();
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьФактическийАдрес()
	
	Если (НЕ ЗначениеЗаполнено(АдресФактическийПредставление) ИЛИ НЕ ЗначениеЗаполнено(АдресФактическийЗначение))
		И (ЗначениеЗаполнено(АдресЮридическийПредставление) ИЛИ ЗначениеЗаполнено(АдресЮридическийЗначение)) Тогда
		
		АдресФактическийЗначение      = АдресЮридическийЗначение;
		АдресФактическийПредставление = АдресЮридическийПредставление;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФактическийПредставлениеНажатие_Завершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	НовыйАдрес = КонтекстЭДОКлиент.РедактироватьАдресКонвертацияРезультата(РезультатЗакрытия, Истина);
	
	Если НовыйАдрес.Модифицированность Тогда
		
		Модифицированность = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"АдресФактическийПредставлениеНажатие_ПослеОбновления", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
		
		КонтекстЭДОКлиент.ОбновитьАдрес(НовыйАдрес, "АдресФактический", ОписаниеОповещения, ЭтоЮридическоеЛицо);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФактическийПредставлениеНажатие_ПослеОбновления(Результат, ВходящийКонтекст) Экспорт
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	// Прорисовываем телефоны (у него отключено Авто обновление текста редактирования)
	// Для предотвращения ошибки, когда номер заполнен не полностью и поэтому не отображается совсем
	Элементы.ТелефонМобильный.ОбновитьТекстРедактирования();
	ТелефонМобильный_ПриИзмененииТекстаРедактирования(ТелефонМобильный);
	Элементы.ТелефонОсновной.ОбновитьТекстРедактирования();
	ТелефонОсновной_ПриИзмененииТекстаРедактирования(ТелефонОсновной, 0.1);
	ЭлектроннаяПочтаДляПаролей_ПриИзмененииТекстаРедактирования(ЭлектроннаяПочтаДляПаролей);
	
	КонтекстЭДОКлиент.ИзменитьПодсказкуРегНомера(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметры(Параметры)
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьМобильногоТелефона(Форма)
	
	Элементы = Форма.Элементы;
	
	// доступность
	Элементы.ТелефонМобильный.Доступность = Форма.ПолучатьСМС;
	
	Если Форма.РежимРаботыСКлючами = 1 Тогда
		
		// Облако. Телефоны могут отличаться
		Элементы.ТелефонМобильный.Видимость = Истина;
		
		Если НЕ ЗначениеЗаполнено(Форма.ТелефонМобильный) И ЗначениеЗаполнено(Форма.ТелефонДляПаролей) Тогда
			Форма.ТелефонМобильный = Форма.ТелефонДляПаролей;
		КонецЕсли;
		
	Иначе
		// Коробка. Телефоны НЕ могут отличаться
		Элементы.ТелефонМобильный.Видимость = Ложь;
		Элементы.ПолучатьСМС.Заголовок 		= НСтр("ru = 'Хочу получать'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеФормы()
	
	Элементы.ГруппаСМСУведомлений.Видимость    = ОператорПоддерживаетСМСУведомление;
	Элементы.ГруппаДолжность.Видимость         = ЭтоЮридическоеЛицо;
	Элементы.ГруппаПодразделение.Видимость     = ЭтоЮридическоеЛицо;
	Элементы.ГруппаРегНомерПрограммы.Видимость = РегНомерВРасширенныхНастройках;
	Элементы.ГруппаДополнителныеСведенияВладельца.Видимость = ЭтоЮридическоеЛицо ИЛИ РегНомерВРасширенныхНастройках;
	
	УстановитьДоступностьМобильногоТелефона(ЭтотОбъект);
	
	// Адреса
	Если ЮрАдресВРасширенныхНастройках Тогда
		ИзменитьОформлениеАдреса("АдресЮридическийПредставление");
	Иначе
		Элементы.ГруппаЮрАдрес.Видимость = Ложь;
		Элементы.ЗаполнитьЮридическийАдресПоФактическому.Видимость = Ложь;
		Элементы.ЗаполнитьФактическийАдресПоЮридическому.Видимость = Ложь;
	КонецЕсли;
	ИзменитьОформлениеАдреса("АдресФактическийПредставление");
	
	ИзменитьОформлениеВладельцаЭЦПДолжность(ЭтотОбъект);
	
	Если ЭтоЮридическоеЛицо Тогда
		Элементы.ЗаголовокТелефонОсновной.Заголовок = НСтр("ru = 'Телефон организации:'");
	Иначе
		Элементы.ЗаголовокТелефонОсновной.Заголовок = НСтр("ru = 'Телефон:'");
	КонецЕсли;
	
	ВидимостьПочты = 
		РежимРаботыСКлючами <> 1 
		И СпособПолученияСертификата = Перечисления.СпособПолученияСертификата.ИспользоватьСуществующий;
		
	Элементы.ГруппаПроверкаЭлектроннойПочты.Видимость = ВидимостьПочты;
	
	ПодсказкаЭлемента = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьОписаниеСпособовПодтвержденияКриптоопераций();
	Элементы.СпособПодтвержденияКриптоопераций.Подсказка = ПодсказкаЭлемента;
	Элементы.ГруппаПодтвержденияКриптоопераций.Видимость = РежимРаботыСКлючами = 1;
	Элементы.Декорация3.Видимость = Элементы.ГруппаПодтвержденияКриптоопераций.Видимость 
									ИЛИ Элементы.ГруппаДополнителныеСведенияВладельца.Видимость;
									
	Если ЗапретитьИзменение Тогда
		
		// Поля
		Элементы.ГруппаДополнительныеКонтакты.ТолькоПросмотр 		 = Истина;
		Элементы.ГруппаДополнителныеСведенияВладельца.ТолькоПросмотр = Истина;
		Элементы.ГруппаПодтвержденияКриптоопераций.ТолькоПросмотр	 = Истина;
		
		// Ссылки
		Элементы.ЗаполнитьЮридическийАдресПоФактическому.Доступность = Ложь;
		Элементы.ЗаполнитьФактическийАдресПоЮридическому.Доступность = Ложь;
		
		// Кнопки
		Элементы.Сохранить.Видимость 	= Ложь;
		Элементы.ФормаЗакрыть.Видимость = Ложь;
		
	КонецЕсли;
	
	// Вывод ошибок
	РезультатПроверки = РеквизитыУказаныКорректно(, Ложь);
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ОтобразитьРезультатПроверкиРеквизитов(ЭтотОбъект, РезультатПроверки);

КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеАдреса(ИмяРеквизита)
	
	РеквизитСАдресом = ЭтотОбъект[ИмяРеквизита];
	ЭлементСАдресом  = Элементы[ИмяРеквизита];
	
	Если ЗначениеЗаполнено(РеквизитСАдресом) И РеквизитСАдресом <> НСтр("ru = 'Заполнить'") Тогда
		ЭлементСАдресом.Заголовок  = РеквизитСАдресом;
		ЭлементСАдресом.ЦветТекста = Новый Цвет;
	Иначе
		ЭлементСАдресом.Заголовок  = НСтр("ru = 'Заполнить'");
		КрасныйЦвет = Новый Цвет(178,34, 34);
		ЭлементСАдресом.ЦветТекста = КрасныйЦвет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеВладельцаЭЦПДолжность(Форма)
	
	Элементы = Форма.Элементы;
	
	// Адрес
	Если Форма.ЭтоЮридическоеЛицо И Форма.Доступен1СКонтрагент 
		И Форма.ВладелецЭЦПТип = ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.Руководитель") Тогда
		
		Элементы.ГруппаДолжность.Видимость = Истина;
		
	Иначе
		
		Элементы.ГруппаДолжность.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Сохранить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаДляПаролейПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ЭлектроннаяПочтаДляПаролей_ПриИзмененииТекстаРедактирования(ЭлектроннаяПочтаДляПаролей, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаДляПаролейИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ЭлектроннаяПочтаДляПаролей_ПриИзмененииТекстаРедактирования(Текст, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаДляПаролей_ПриИзмененииТекстаРедактирования(Текст, ИзмененоВручную = Ложь)
	
	Если ИзмененоВручную Тогда
		Пауза = 1.5;
	Иначе
		Пауза = 0.1;
	КонецЕсли;
	
	ЭлектроннаяПочтаДляПаролей = Текст;
	
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьЭлектроннаяПочтаДляПаролей");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьЭлектроннаяПочтаДляПаролей", Пауза, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьЭлектроннаяПочтаДляПаролей()
	
	Если ЗначениеЗаполнено(ЭлектроннаяПочтаДляПаролей) Тогда
		Элементы.ЭлектроннаяПочтаДляПаролей.ОбновитьТекстРедактирования();
	КонецЕсли;
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

#КонецОбласти